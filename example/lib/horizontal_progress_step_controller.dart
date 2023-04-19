import 'package:get/get.dart';
import 'package:steppers/stepper_data.dart';

class HorizontalProgressStepController extends GetxController {

  var currentStep = 1.obs;
  var totalSteps = 0;
  var hasError = false;

  final stepsData = [
    StepperData(
      label: 'Step 1',
    ),
    StepperData(
      label: 'Step 2',
    ),
    StepperData(
      label: 'Step 3',
    ),
    StepperData(
      label: 'Step 4',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    totalSteps = stepsData.length;
  }

  void nextStep() {
    _doWork();
    if (currentStep.value > totalSteps) { // reset - test only
      currentStep.value = 1;
      return;
    }
    if(stepsData[currentStep.value-1].state != StepperState.error) {
      currentStep.value++;
    }
  }

  _fakeErrorOccurs() {
    hasError = true;
    stepsData[currentStep.value - 1].state = StepperState.error;
    currentStep.refresh();
  }

  _doWork() {
    if(currentStep.value == totalSteps - 1){
      _fakeErrorOccurs();
    }
  }

  fixError() {
    if(!hasError) return;
    hasError = false;
    stepsData[currentStep.value - 1].state = StepperState.normal;
    currentStep.value++;
  }
}
