import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class speech_to_text extends StatefulWidget {
  const speech_to_text({Key? key}) : super(key: key);

  @override
  State<speech_to_text> createState() => _speech_to_textState();
}

class _speech_to_textState extends State<speech_to_text> {
  SpeechToText speechtotext = SpeechToText();
  var text = 'Hold the button and start speaking';
  var isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: Duration(milliseconds: 2000),
        glowColor: Colors.lightBlueAccent,
        repeat: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async{
            if(!isListening){
              var available = await speechtotext.initialize();
              if(available){
                setState(() {
                  isListening = true;
                  speechtotext.listen(
                    onResult: (result){
                      setState(() {
                        text = result.recognizedWords;
                      });
                    }
                  );
                });
              }
            }
          },
          onTapUp: (details){
            setState(() {
              isListening = false;
            });
            speechtotext.stop();
          },
          child: CircleAvatar(
            backgroundColor: Colors.lightBlueAccent,
            radius: 35,
            child: Icon(isListening ? Icons.mic : Icons.mic_none, color:Colors.white),
          ),
        ),
        // child: CircleAvatar(
        //   backgroundColor: Colors.lightBlueAccent,
        //   radius: 35,
        //   child: Icon(isListening ? Icons.mic : Icons.mic_none, color : Colors.white),
        // ),
      ),

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Speech to text", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),),
      ),
      body: SingleChildScrollView(
        reverse: true,
          physics: const BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          margin: EdgeInsets.only(bottom: 150),
          child: Text(text, style: TextStyle(fontSize: 20, color: isListening ? Colors.black87 : Colors.black54, fontWeight: FontWeight.w400),),
        ),
      ),
    );
  }
}
