import 'package:flutter/material.dart';
import 'package:sharezone/sharezone_wrapped/sharezone_wrapped_image.dart';
import 'package:sharezone/sharezone_wrapped/sharezone_wrapped_view.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SharezoneWrappedPage extends StatelessWidget {
  const SharezoneWrappedPage({super.key});

  static const tag = "sharezone-Wrapped-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: MaxWidthConstraintBox(
            maxWidth: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Container(
                    // add border
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: darkBlueColor,
                        width: 4,
                      ),
                    ),
                    child: SharezoneWrappedImage(
                      view: SharezoneWrappedView.fromValues(
                        totalAmountOfLessonHours: 1200,
                        amountOfLessonHoursTopThreeCourses: [
                          ("Math", 400),
                          ("English", 300),
                          ("Physics", 200)
                        ],
                        totalAmountOfHomeworks: 92,
                        amountOfHomeworksTopThreeCourses: [
                          ("Math", 30),
                          ("English", 25),
                          ("Physics", 20)
                        ],
                        totalAmountOfExams: 60,
                        amountOfExamsTopThreeCourses: [
                          ("Math", 20),
                          ("English", 15),
                          ("Physics", 10)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Wrapped',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Schuljahr 23/23',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hier ist dein Schuljahr in Zahlen. Teile es mit deinen Freunden auf Instagram, TikTok und Co.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                  label: Text("Teilen"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
