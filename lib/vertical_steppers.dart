import 'package:steppers/colors.dart';
import 'package:flutter/material.dart';
import 'stepper_icon.dart';
import 'stepper_data.dart';
import 'stepper_style.dart';
import 'style.dart';


class VerticalSteppers extends StatelessWidget {
  VerticalSteppers({
    Key? key,
    List<int>? features,
    required this.labels,
    required this.currentStep,
    this.stepBarStyle,
  });

  List<StepperData> labels;
  int currentStep;
  StepperStyle? stepBarStyle;
  get _totalSteps => labels.length;
  get _stepBarStyle => stepBarStyle ??= StepperStyle();

  @override
  Widget build(BuildContext context) {
    assert(1 < _totalSteps && _totalSteps < 5 && currentStep <= _totalSteps + 1, 'Invalid progress steps');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildListStepWidgets(),
    );
  }

  _buildListStepWidgets() {
    List<Widget> widgets = [];
    labels.asMap().forEach((index, stepData) {
      widgets.add(_buildProgressItemWidget(
        step: index + 1,
        stepData: stepData,
      ));
    });
    return widgets;
  }

  _buildProgressItemWidget({required StepperData stepData, required int step}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: (step == currentStep && stepData.state != StepperState.error)
                      ? _stepBarStyle.activeBorderColor
                      : StepperColors.transparent,
                  shape: BoxShape.circle,
                ),
                child: StepperIcon(
                  step: step,
                  currentStep: currentStep,
                  stepBarStyle: _stepBarStyle,
                  stepData: stepData,
                ),
              ),
              _buildSeparatorLine(step, stepData),
            ],
          ),
          _buildStepContentWidget(step, stepData),
        ],
      ),
    );
  }

  Widget _buildSeparatorLine(int step, StepperData stepData) {
    return Expanded(
      child: Container(
        width: 1,
        color: _dividerColor(step, stepData),
      ),
    );
  }

  _isEmpty(String? text) => text == null || text.isEmpty;

  _dividerColor(int step, StepperData stepData) {
    if(step == _totalSteps && stepData.child == null && _isEmpty(stepData.description)) return StepperColors.transparent;
    if(step < _totalSteps && labels[step].state == StepperState.error) return StepperColors.red500;
    return currentStep > step ? _stepBarStyle.activeColor : _stepBarStyle.inactiveColor;
  }

  _buildStepContentWidget(int step, StepperData stepData) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stepData.label,
              style: StepperStyles.t16SB.copyWith(color: _labelColor(step, stepData)),
            ),
            if (!_isEmpty(stepData.description))
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  stepData.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: StepperStyles.t14R.copyWith(color: _descriptionColor(step, stepData)),
                ),
              ),
            stepData.child ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  _labelColor(int step, StepperData stepData) {
    if(stepData.state == StepperState.error) return StepperColors.red500;
    return currentStep >= step ? _stepBarStyle.activeColor : _stepBarStyle.inactiveColor;
  }

  _descriptionColor(int step, StepperData stepData) {
    if(stepData.state == StepperState.error) return _stepBarStyle.inactiveDescriptionTextColor;
    return currentStep >= step ? _stepBarStyle.activeDescriptionTextColor : _stepBarStyle.inactiveDescriptionTextColor;
  }
}