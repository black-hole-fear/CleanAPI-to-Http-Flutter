import 'package:clean_api/clean_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:Taillz/Localization/t_keys.dart';
import 'package:Taillz/application/story/get/create/create_story_provider.dart';
import 'package:Taillz/application/story/get/create/create_story_state.dart';
import 'package:Taillz/application/story/get/create/topic_provider.dart';
import 'package:Taillz/application/story/get/story_provider.dart';
import 'package:Taillz/screens/thoughts/components/thought_detail_text_field.dart';
import 'package:Taillz/screens/thoughts/controller.dart/autogenerated_background.dart';
import 'package:Taillz/utills/constant.dart';
import 'package:Taillz/widgets/custom_flushbar.dart';
import 'package:url_launcher/url_launcher.dart';

class WriteUs extends HookConsumerWidget {
  WriteUs({Key? key}) : super(key: key);

  final generate = Get.find<AutoGenBackground>();

  @override
  Widget build(BuildContext context, ref) {
    final selectedTitle = useState(TKeys.SelectATitle.translate(context));

    List<String> topicsList = [
      TKeys.SelectATitle.translate(context),
      TKeys.JoinAsCoacherPersonal.translate(context),
      TKeys.JoinAsCoacherRelationship.translate(context),
      TKeys.JoinAsCoacherParenting.translate(context),
      TKeys.JoinAsCoacherBusiness.translate(context),
      TKeys.Improvement.translate(context),
      TKeys.Other.translate(context),
    ];
    // TODO
    // StoryProvider _storyProvider = StoryProvider();
    // TODO
    // final topics = ref.watch(topicProvider);
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 100), () {
        ref.read(topicProvider.notifier).getTopics();
        return const Center(
          child: CircularProgressIndicator(),
        );
      });
      return null;
    }, []);
    final TextEditingController thoughtsController = useTextEditingController();
    // TODO
    // final commentStatus = useState(1);

    final isLoading = useState(false);
    // TODO
    // bool isLoad = false;
    // TODO
    // final ValueNotifier topic = useState(null);

    ref.listen<CreateStoryState>(createStoryProvider, (previous, next) {
      if (previous?.loading != true && next.loading) {
        isLoading.value = true;
      } else if (previous?.loading == true && !next.loading) {
        isLoading.value = false;
      }
      if (next.failure != CleanFailure.none()) {
        // Navigator.pop(context);
      }
      if (!next.loading && next.failure == CleanFailure.none()) {
        ref.read(storyProvider.notifier).getStories();
        Navigator.pop(context);
        isLoading.value = false;
      }
    });

    return Scaffold(
      body: Column(
        children: [
          isLoading.value == true
              ? const SafeArea(
                  child: Center(
                    child: LinearProgressIndicator(
                      color: Color(0xff19334D),
                      minHeight: 2,
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              : SafeArea(
                  child: Container(
                  height: 70,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          generate.generate(0);
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 27,
                          color: Color(0xff19334D),
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      TextButton(
                        onPressed: () async {

                          if (thoughtsController.text.length < 50) {
                            showFlushBar(
                                context,
                                TKeys.minimum_for_personal_for_email
                                    .translate(context));
                          } else if (selectedTitle.value ==
                              TKeys.SelectATitle.translate(context)) {
                            showFlushBar(
                                context, TKeys.SelectATitle.translate(context));
                          } else {
                            await launchUrl(Uri.parse(
                                    'mailto:support@Taillz.com?subject=${selectedTitle.value.toString()}&body=${thoughtsController.text.toString()}'))
                                .then((value) {});
                            thoughtsController.text = '';
                          }
                        },
                        child: Text(
                          TKeys.send.translate(context),
                          style: TextStyle(
                            color: Constants.blueColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constants.fontFamilyName,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 230,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 17, vertical: 4),
                    decoration: BoxDecoration(
                        color: Constants.editTextBackgroundColor,
                        // border: Border.all(
                        //     color: Colors.grey.withOpacity(0.5), width: 1),
                        borderRadius: BorderRadius.circular(100)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          hint: Row(
                            children: [
                              Text(
                                TKeys.titleForWriteUs.translate(context),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down_sharp),
                          isExpanded: true,
                          value: selectedTitle.value,
                          items:
                              topicsList.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Constants.vertIconColor),
                              ),
                            );
                          }).toList(),
                          onChanged: (dynamic value) {
                            selectedTitle.value = value;
                          }),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 15.0, left: 5, right: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Constants.editTextBackgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ThoughtDetailTextFieldForWriteUs(
                                textEditingController: thoughtsController,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
