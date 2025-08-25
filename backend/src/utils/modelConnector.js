import connection from "../configs/connectDB.js";

// Store for schema registrations
const schemaRegistry = new Map();
const modelCache = new Map();

/**
 * Register a schema that will be used to create models later
 * @param {string} modelName - The name of the model
 * @param {object} schema - The mongoose schema
 * @param {string} connectionType - Which connection to use ('main' or 'chat')
 */
export const registerSchema = (modelName, schema, connectionType = 'main') => {
  const key = `${modelName}_${connectionType}`;
  schemaRegistry.set(key, { modelName, schema, connectionType });
};


//Initialize all registered models after connection is established

export const initializeModels = () => {
  console.log('Initializing models...');
  for (const [key, { modelName, schema, connectionType }] of schemaRegistry) {
    if (connection[connectionType]) {
      try {
        const model = connection[connectionType].model(modelName, schema);
        modelCache.set(key, model);
        console.log(`Model ${modelName} initialized successfully`);
      } catch (error) {
        if (error.message.includes('Cannot overwrite')) {
          // Model already exists
          const model = connection[connectionType].model(modelName);
          modelCache.set(key, model);
          console.log(`Model ${modelName} already exists, using existing model`);
        } else {
          console.error(`Error initializing model ${modelName}:`, error.message);
        }
      }
    }
  }
};

/**
 * Get a model by name
 * @param {string} modelName - The name of the model
 * @param {string} connectionType - Which connection to use ('main' or 'chat')
 * @returns {object} The mongoose model
 */
export const getModel = (modelName, connectionType = 'main') => {
  const key = `${modelName}_${connectionType}`;
  const model = modelCache.get(key);
  
  if (!model) {
    throw new Error(`Model ${modelName} not found. Make sure models are initialized after database connection.`);
  }
  
  return model;
};

/**
 * Creates a model placeholder that will be initialized later
 * @param {string} modelName - The name of the model
 * @param {object} schema - The mongoose schema
 * @param {string} connectionType - Which connection to use ('main' or 'chat')
 * @returns {Proxy} A proxy that acts like a Mongoose model
 */
export const createModel = (modelName, schema, connectionType = 'main') => {
  // Register schema for later initialization
  registerSchema(modelName, schema, connectionType);

  // This will hold the actual model once initialized
  let modelInstance = null;

  // Helper to get the actual model (throws if not initialized)
  const getActualModel = () => {
    if (!modelInstance) {
      const key = `${modelName}_${connectionType}`;
      modelInstance = modelCache.get(key);
      if (!modelInstance) {
        throw new Error(
          `Model ${modelName} not found. Ensure initializeModels() is called after DB connection.`
        );
      }
    }
    return modelInstance;
  };

  // Return a Proxy that intercepts all property/method access
  return new Proxy(
    function () {
      // Allow the proxy to be used as a constructor: new Model()
      const model = getActualModel();
      return new (Function.prototype.bind.apply(model, arguments))();
    },
    {
      // Handle property access (e.g., Model.schema, Model.modelName)
      get(target, prop) {
        const model = getActualModel();

        const value = model[prop];
        if (typeof value === 'function') {
          // Bind functions to the model context
          return value.bind(model);
        }
        return value;
      },

      // Allow setting properties (rarely used, but just in case)
      set(target, prop, value) {
        const model = getActualModel();
        model[prop] = value;
        return true;
      },

      // Support for instanceof checks (optional)
      has(target, prop) {
        const model = getActualModel();
        return prop in model;
      },

      // Make the proxy appear like the real model in console.log
      ownKeys() {
        const model = getActualModel();
        return [...new Set([...Object.keys(model), ...Object.getOwnPropertyNames(model.constructor.prototype)])];
      },

      getOwnPropertyDescriptor(target, prop) {
        const model = getActualModel();
        const desc = Object.getOwnPropertyDescriptor(model, prop);
        if (desc) return desc;
        // Also check prototype chain
        const protoDesc = Object.getOwnPropertyDescriptor(model.constructor.prototype, prop);
        return protoDesc;
      },

      // Handle constructor calls (new Model())
      construct(target, args) {
        const model = getActualModel();
        return new model(...args);
      }
    }
  );
};
