import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/job_entries/job_entries_page.dart';
import 'package:my_time_tracker/app/home/jobs/job_list_tile.dart';
import 'package:my_time_tracker/app/home/jobs/customListBuilder.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/common_widgets/custom_icon_text_field.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/show_snack_bar.dart';
import 'package:my_time_tracker/services/connectivity_provider.dart';
import 'package:my_time_tracker/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'edit_job_page.dart';

class JobsPage extends StatefulWidget {
  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final TextEditingController _searchController = TextEditingController();
  FocusNode _searchNode;
  final Color uniqueJobsPageColor = Color.fromRGBO(0, 195, 111, 0.5);
  List<Job> _allJobsList = [];
  List<Job> _displayedResultsList = [];
  Future<void> resultLoaded;
  bool showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _searchNode = FocusNode();
    _searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    _searchNode.dispose();
    _searchController.removeListener(onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultLoaded = getAllList();
  }

  void onSearchChanged() {
    getDisplayedResultList();
  }

  void getDisplayedResultList() {
    List<Job> _searchResultList = [];

    if (_searchController.text != '') {
      for (final job in _allJobsList) {
        final name = job.name.toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          _searchResultList.add(job);
        }
      }
    } else {
      _searchResultList = List.from(_allJobsList);
    }

    setState(() {
      _displayedResultsList = _searchResultList;
    });
  }

  Future<void> getAllList() async {
    List<Job> allJobs =
        await Provider.of<Database>(context, listen: false).jobsList();
    setState(() {
      _allJobsList = allJobs;
    });
    getDisplayedResultList();
  }

  Future<void> _confirmDelete(BuildContext context, Job job) async {
    final didRequestDelete = await PlatformAlertDialog(
      title: 'Delete',
      content: 'Would you like to delete this job?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Delete',
    ).show(context);
    if (didRequestDelete == true) {
      _delete(context, job);
      MyCustomSnackBar(
        text: '${job.name} removed successfully.',
      ).show(context);
    }
  }

  void _navigateAndDisplayResult(BuildContext context, {Job job}) async {
    final result = await EditJobPage.show(context, job: job);
    if (result == false) {
      getAllList();
    }
  }

  Future<void> _delete(BuildContext context, Job job) async {
    _allJobsList.remove(job);
    getDisplayedResultList();
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } catch (e) {
      PlatformExceptionAlertDialog(
        exception: e,
        title: 'Operation failed',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
        builder: (context, _isConnected, child) =>
            _buildScaffold(context, _isConnected));
  }

  Widget _buildScaffold(
      BuildContext context, ConnectivityProvider isConnected) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: uniqueJobsPageColor,
        title: Text(
          'My Jobs',
          style: CustomTextStyles.textStyleTitle(),
        ),
        centerTitle: false,
        elevation: 5.0,
        actions: [
          IconButton(
            icon: Icon(Icons.search_sharp),
            tooltip: 'Search Job',
            iconSize: 30.0,
            onPressed: () {
              setState(() {
                showSearchBar = !showSearchBar;
                _searchController.clear();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add Job',
            iconSize: 30.0,
            onPressed: () => _navigateAndDisplayResult(context),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          color: uniqueJobsPageColor.withOpacity(0.1),
          child: Column(
            children: [
              if (showSearchBar)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(
                      color: uniqueJobsPageColor,
                      width: 4,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomIconTextField(
                    iconColor: Colors.deepOrangeAccent,
                    border: InputBorder.none,
                    icon: Icons.search_sharp,
                    focusNode: _searchNode,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.text,
                    labelText: 'Search your job here',
                    controller: _searchController,
                  ),
                ),
              Expanded(
                child: _buildContents(context, isConnected),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContents(
      BuildContext context, ConnectivityProvider isConnected) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: CustomListBuilder(
        customList: _displayedResultsList,
        scrollBarColor: uniqueJobsPageColor,
        itemBuilder: (context, int index) {
          Job job = _displayedResultsList[index];
          return Slidable(
            key: Key('job:${job.id}'),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
            secondaryActions: [
              IconSlideAction(
                caption: 'Edit',
                color: Colors.black45,
                icon: Icons.edit,
                onTap: () => _navigateAndDisplayResult(context, job: job),
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  if (isConnected.online) {
                    _confirmDelete(context, job);
                  } else {
                    MyCustomSnackBar(
                      text: 'No internet connection!',
                    ).show(context);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
