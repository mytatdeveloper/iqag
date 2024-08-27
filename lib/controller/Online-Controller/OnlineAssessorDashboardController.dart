import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mytat/model/AssesmentQuestionsModel.dart';
import 'package:mytat/model/GridCardModel.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/utilities/ImageUrls.dart';
import 'package:mytat/view/Assessor-Module/assessor_completed_students_theory_screen.dart';
import 'package:mytat/view/Assessor-Module/student_list_screen.dart';
import 'package:mytat/view/Online-Mode/assessor_documents_management_Screen_online.dart';

class OnlineAssessorDashboardController extends GetxController {
  List<GridCardModel> get documentManagement => _documentManagement;
  List<GridCardModel> get vivaManagement => _vivaManagement;
  List<GridCardModel> get studentTheory => _studentTheory;

  final List<GridCardModel> _documentManagement = [
    GridCardModel(
        icon: ImageUrls.documentIcon,
        title: "Documents",
        screeToNavigate: const OnlineAssessorDocumentsManagementScreen()
        // const AssessorDocumentsManagementScreen()
        ),
  ];

  final List<GridCardModel> _vivaManagement = [
    GridCardModel(
        icon: ImageUrls.startViva,
        title: "Start P/V",
        screeToNavigate: const StudentListScreen()),
  ];

  final List<GridCardModel> _studentTheory = [
    GridCardModel(
        icon: ImageUrls.gifStudentsList,
        title: "Student List",
        screeToNavigate: const AllTheoryCompletedStudentsList()),
  ];

  List<MQuestions> tempMQuestionsList = [];
  List<VQuestions> tempVQuestionsList = [];
  List<PQuestions> tempPQuestionsList = [];

  getAllTemporaryQuestionsList() async {
    tempMQuestionsList = [];
    tempVQuestionsList = [];
    tempPQuestionsList = [];
    DatabaseHelper dbHelper = DatabaseHelper();
    tempMQuestionsList = await dbHelper.getMQuestions();
    print("MQuestions Length ==> ${tempMQuestionsList.length}");
    tempPQuestionsList = await dbHelper.getPQuestions();
    print("PQuestions Length ==> ${tempPQuestionsList.length}");
    tempVQuestionsList = await dbHelper.getVQuestions();
    print("VQuestions Length ==> ${tempVQuestionsList.length}");
    update();
  }
}
