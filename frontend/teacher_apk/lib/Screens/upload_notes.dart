// ================== Imports ==================
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:teacher_apk/Screens/dashboard_page.dart';
import 'package:teacher_apk/theme.dart';
import 'package:teacher_apk/widgets/triangle_logo.dart';

// ================== Uploaded Note Data Model ==================
class UploadedNoteData {
  final String subject;
  final String category;
  final String documentTitle;
  final String? chapterName;
  final int? chapterNumber;
  final String fileName;
  final DateTime? scheduledDate;
  final TimeOfDay? scheduledTime;
  final DateTime submissionTime;

  UploadedNoteData({
    required this.subject,
    required this.category,
    required this.documentTitle,
    this.chapterName,
    this.chapterNumber,
    required this.fileName,
    this.scheduledDate,
    this.scheduledTime,
    required this.submissionTime,
  });
}

// ================== Upload Notes Screen ==================
class UploadNotesScreen extends StatefulWidget {
  const UploadNotesScreen({super.key});

  @override
  State<UploadNotesScreen> createState() => _UploadNotesScreenState();
}

class _UploadNotesScreenState extends State<UploadNotesScreen> {
  final List<UploadedNoteData> _previousUploads = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          extendBodyBehindAppBar: true,

          // ================== AppBar ==================
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardPage()),
                  );
                },
              ),
            ),
            title: const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Upload Notes",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: const CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: TriangleLogo(size: 20.0, isWhite: true),
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kTextTabBarHeight + 40.0 + 8.0 + 1.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 55.0), child: Text("New"))),
                        Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 55.0), child: Text("Previous"))),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    height: 1.0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 8.0),
                  ),
                ],
              ),
            ),
          ),

          // ================== Body ==================
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.backgroundGradientStart,
                  AppTheme.backgroundGradientEnd,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: TabBarView(
              children: [
                // ================== New Upload Tab ==================
                Builder(
                  builder: (BuildContext tabContext) {
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: tabContext,
                            builder: (BuildContext dialogContext) {
                              String? selectedSubject;
                              String? selectedCategory;
                              int? selectedChapter;
                              final TextEditingController chapterNameController = TextEditingController();
                              final TextEditingController documentTitleController = TextEditingController();
                              final TextEditingController dateController = TextEditingController();
                              final TextEditingController timeController = TextEditingController();
                              DateTime? selectedDate;
                              TimeOfDay? selectedTime;
                              String? selectedFileName;
                              List<String> subjects = ["AD", "PS", "DSA"];
                              List<String> categories = ["Notes", "Assignments", "Projects", "Quiz", "PYQs", "lab"];
                              List<int> chapters = List<int>.generate(20, (i) => i + 1);
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setStateDialog) {
                                  return AlertDialog(
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          DropdownButtonFormField<String>(
                                            decoration: const InputDecoration(hintText: "Select Subject", hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54)),
                                            style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                                            value: selectedSubject,
                                            onChanged: (String? newValue) {
                                              setStateDialog(() {
                                                selectedSubject = newValue;
                                              });
                                            },
                                            items: subjects.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black)))).toList(),
                                          ),
                                          const SizedBox(height: 16.0),
                                          DropdownButtonFormField<String>(
                                            decoration: const InputDecoration(hintText: "Choose Category", hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54)),
                                            style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                                            value: selectedCategory,
                                            onChanged: (String? newValue) {
                                              setStateDialog(() {
                                                selectedCategory = newValue;
                                                if (selectedCategory != "Notes") {
                                                  selectedChapter = null;
                                                  chapterNameController.clear();
                                                }
                                              });
                                            },
                                            items: categories.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black)))).toList(),
                                          ),
                                          const SizedBox(height: 16.0),
                                          if (selectedCategory == "Notes") ...[
                                            DropdownButtonFormField<int>(
                                              decoration: const InputDecoration(hintText: "Choose Chapter No.", hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54)),
                                              style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                                              value: selectedChapter,
                                              onChanged: (int? newValue) {
                                                setStateDialog(() {
                                                  selectedChapter = newValue;
                                                });
                                              },
                                              items: chapters.map<DropdownMenuItem<int>>((int value) => DropdownMenuItem<int>(value: value, child: Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black)))).toList(),
                                            ),
                                            const SizedBox(height: 16.0),
                                            TextFormField(
                                              controller: chapterNameController,
                                              decoration: const InputDecoration(hintText: "Enter Chapter Name", hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54)),
                                              style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                                            ),
                                            const SizedBox(height: 16.0),
                                          ],
                                          TextFormField(
                                            controller: documentTitleController,
                                            decoration: const InputDecoration(hintText: "Enter Document Title", hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54)),
                                            style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                                          ),
                                          const SizedBox(height: 24.0),
                                          const Text("Scheduled upload", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                                          const SizedBox(height: 8.0),
                                          const Text("If you want to schedule the sending of notes, mention date & time.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black54)),
                                          const SizedBox(height: 16.0),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: TextFormField(
                                                  controller: dateController,
                                                  readOnly: true,
                                                  decoration: const InputDecoration(hintText: "Select Date", suffixIcon: Icon(Icons.calendar_today), hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54)),
                                                  style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                                                  onTap: () async {
                                                    DateTime? pickedDate = await showDatePicker(context: context, initialDate: selectedDate ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2101));
                                                    if (pickedDate != null) {
                                                      setStateDialog(() {
                                                        selectedDate = pickedDate;
                                                        dateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Expanded(
                                                child: TextFormField(
                                                  controller: timeController,
                                                  readOnly: true,
                                                  decoration: const InputDecoration(hintText: "Select Time", suffixIcon: Icon(Icons.access_time), hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54)),
                                                  style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                                                  onTap: () async {
                                                    TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: selectedTime ?? TimeOfDay.now());
                                                    if (pickedTime != null && context.mounted) {
                                                      setStateDialog(() {
                                                        selectedTime = pickedTime;
                                                        timeController.text = pickedTime.format(context);
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 24.0),
                                          const Align(alignment: Alignment.centerLeft, child: Text("Attach Document", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))),
                                          const SizedBox(height: 8.0),
                                          Row(
                                            children: <Widget>[
                                              OutlinedButton.icon(
                                                icon: const Icon(Icons.attach_file, size: 18),
                                                label: const Text("Choose File", style: TextStyle(fontWeight: FontWeight.w300)),
                                                onPressed: () {
                                                  setStateDialog(() {
                                                    selectedFileName = "syllabus_choosen.pdf";
                                                  });
                                                },
                                                style: OutlinedButton.styleFrom(foregroundColor: AppTheme.primaryColor, side: BorderSide(color: AppTheme.primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                                              ),
                                              const SizedBox(width: 16.0),
                                              Expanded(child: Text(selectedFileName ?? "No file selected", style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black54), overflow: TextOverflow.ellipsis)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(dialogContext).pop()),
                                      TextButton(
                                        child: const Text("Submit"),
                                        onPressed: () {
                                          String? errorMessage;
                                          if (selectedSubject == null) {
                                            errorMessage = "Please select a subject.";
                                          } else if (selectedCategory == null) {
                                            errorMessage = "Please choose a category.";
                                          } else if (documentTitleController.text.isEmpty) {
                                            errorMessage = "Please enter a document title.";
                                          } else if (selectedCategory == "Notes" && selectedChapter == null) {
                                            errorMessage = "Please choose a chapter number for Notes.";
                                          } else if (selectedCategory == "Notes" && chapterNameController.text.isEmpty) {
                                            errorMessage = "Please enter a chapter name for Notes.";
                                          } else if (selectedFileName == null) {
                                            errorMessage = "Please attach a document.";
                                          }
                                          if (errorMessage != null) {
                                            ScaffoldMessenger.of(tabContext).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
                                          } else {
                                            final newUpload = UploadedNoteData(
                                              subject: selectedSubject!,
                                              category: selectedCategory!,
                                              documentTitle: documentTitleController.text,
                                              chapterName: selectedCategory == "Notes" ? chapterNameController.text : null,
                                              chapterNumber: selectedCategory == "Notes" ? selectedChapter : null,
                                              fileName: selectedFileName!,
                                              scheduledDate: selectedDate,
                                              scheduledTime: selectedTime,
                                              submissionTime: DateTime.now(),
                                            );
                                            setState(() {
                                              _previousUploads.add(newUpload);
                                            });
                                            Navigator.of(dialogContext).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: Container(
                                  width: 180.0,
                                  height: 180.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha((255 * 0.2).round()),
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(color: Colors.white.withAlpha((255 * 0.3).round())),
                                  ),
                                  child: Center(child: Icon(Icons.upload_file, size: 120.0, color: AppTheme.primaryColor)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text("Upload Notes", style: TextStyle(color: AppTheme.primaryColor, fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      );
                  },
                ),

                // ================== Previous Uploads Tab ==================
                _previousUploads.isEmpty
                    ? const Center(child: Text("No uploads yet.", style: TextStyle(color: Colors.black54, fontSize: 16)))
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: kToolbarHeight + kTextTabBarHeight + 110, left: 8, right: 8, bottom: 8),
                        itemCount: _previousUploads.length,
                        itemBuilder: (context, index) {
                          final item = _previousUploads[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            elevation: 3,
                            child: ListTile(
                              leading: Icon(Icons.description, color: AppTheme.primaryColor),
                              title: Text(item.documentTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text("Category: ${item.category}\nSubject: ${item.subject}${item.chapterNumber != null ? '\nChapter: ${item.chapterNumber} - ${item.chapterName}' : ''}\nFile: ${item.fileName}"),
                              trailing: Text(item.submissionTime.toLocal().toString().substring(0, 16)),
                              isThreeLine: item.category == "Notes" && item.chapterNumber != null,
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
