import 'package:flutter/material.dart';

final Map<String, String> botResponses = {
  // Greetings & Chitchat
  'hello': 'Hello! How can I help you today?',
  'hi': 'Hi there! How can I assist you?',
  'hey': 'Hey! How can I help you?',
  'how are you': 'I am just a bot, but I am here to help you!',
  'good morning': 'Good morning! How can I help you?',
  'good afternoon': 'Good afternoon! How can I help you?',
  'good evening': 'Good evening! How can I help you?',
  'good night': 'Good night! Take care.',
  'thank you': 'You\'re welcome!',
  'thanks': 'Glad to help!',
  'bye': 'Goodbye! Stay healthy.',
  'see you': 'See you soon! Stay healthy.',
  'who are you': 'I am your health assistant chatbot.',
  'what is your name': 'I am ChronoCare Bot.',
  'help': 'You can ask me about diseases, medicines, or general health tips.',
  'age': 'I am ageless, but always ready to help!',
  'weather': 'I can only help with health-related queries.',
  'joke': 'Why did the computer go to the doctor? Because it had a virus!',
  'how old are you': 'I am as old as the code that created me!',
  'what can you do': 'I can answer questions about health, medicines, and general wellness.',
  'who made you': 'I was created by the ChronoCare team.',
  'are you a robot': 'Yes, I am a virtual assistant bot.',
  'do you sleep': 'I never sleep, always here to help you!',
  'do you eat': 'I do not eat, but I recommend a healthy diet for you!',
  'how is your day': 'My day is great, helping you makes it better!',
  'nice to meet you': 'Nice to meet you too!',
  'goodbye': 'Goodbye! Take care of your health.',
  'can you help me': 'Of course! Ask me anything about health or medicines.',
  'what do you like': 'I like helping people stay healthy.',
  'are you real': 'I am a virtual assistant, real in the digital world!',
  'do you have friends': 'My friends are all the users who chat with me.',
  'tell me a joke': 'Why did the math book look sad? Because it had too many problems!',
  'sing a song': 'I wish I could sing, but I can give you health tips!',
  'dance': 'I can\'t dance, but I can help you with health advice!',
  'do you love me': 'I am here to help you, always!',
  'are you happy': 'I am always happy to help!',
  'are you sad': 'I do not feel sad, but I am here if you want to talk.',
  'what is your favorite color': 'I like green, the color of health!',
  'what is your favorite food': 'I recommend fruits and vegetables!',
  'do you have a family': 'My family is everyone who uses ChronoCare.',
  'can you speak urdu': 'I can understand some Urdu, but I reply in English.',
  'can you speak hindi': 'I can understand some Hindi, but I reply in English.',
  'can you speak punjabi': 'I can understand some Punjabi, but I reply in English.',
  'can you speak arabic': 'I can understand some Arabic, but I reply in English.',
  'can you speak french': 'I can understand some French, but I reply in English.',
  'do you have emotions': 'I am a bot, but I care about your health!',
  'do you get tired': 'Never! I am always ready to help.',
  'do you get sick': 'I do not get sick, but I can help you if you do.',
  'do you have a job': 'My job is to help you with health information.',
  'do you have a hobby': 'My hobby is answering your questions!',
  'do you like sports': 'I recommend regular exercise for good health.',
  'do you like music': 'Music is good for relaxation!',
  'do you like movies': 'I do not watch movies, but I can suggest health documentaries!',
  'do you like reading': 'Reading health tips is my favorite!',
  'do you like traveling': 'I travel the internet to help you!',
  'do you like games': 'Brain games are good for mental health!',
  'do you like technology': 'I am made of technology!',
  'do you like nature': 'Nature is great for your health!',
  'do you like animals': 'Pets can be good for mental health!',
  'do you like children': 'Children are the future, keep them healthy!',
  'do you like old people': 'Elderly people need special care and love.',
  'do you like summer': 'Stay hydrated in summer!',
  'do you like winter': 'Keep warm and avoid colds in winter!',
  'do you like rain': 'Rain is refreshing, but avoid getting wet if you have a cold.',
  'do you like sun': 'Sunlight is a good source of Vitamin D!',
  'do you like moon': 'The moon is beautiful, but I am more interested in your health!',
  'do you like stars': 'Stars are nice, but you are a star for taking care of your health!',
  // Medical & Health
  'fever': 'Fever is a common symptom. Please stay hydrated and consult a doctor if it persists.',
  'diabetes': 'Diabetes affects blood sugar levels. Regular exercise and a healthy diet help manage it.',
  'paracetamol': 'Paracetamol is used to treat pain and fever. Use as directed by your doctor.',
  'headache': 'Headache can have many causes. If it is severe or persistent, consult a healthcare professional.',
  'covid': 'COVID-19 is a viral infection. Common symptoms include fever, cough, and loss of taste or smell.',
  'asthma': 'Asthma is a condition that affects breathing. Avoid triggers and use inhalers as prescribed.',
  'hypertension': 'Hypertension means high blood pressure. Reduce salt intake and manage stress.',
  'cancer': 'Cancer is a group of diseases involving abnormal cell growth. Early detection is important.',
  'allergy': 'Allergies can cause sneezing, itching, and rashes. Avoid allergens and consult a doctor.',
  'cold': 'Common cold is caused by viruses. Rest and fluids help recovery.',
  'flu': 'Flu symptoms include fever, chills, and body aches. Get plenty of rest.',
  'antibiotic': 'Antibiotics treat bacterial infections. Do not use without doctor\'s advice.',
  'painkiller': 'Painkillers help reduce pain. Use as prescribed.',
  'insulin': 'Insulin is used to manage diabetes. Follow your doctor\'s instructions.',
  'blood pressure': 'Normal blood pressure is around 120/80 mmHg.',
  'sugar': 'Normal fasting blood sugar is 70-100 mg/dL.',
  'heart attack': 'Heart attack symptoms include chest pain and shortness of breath. Call emergency services immediately.',
  'stroke': 'Stroke symptoms include sudden weakness, confusion, and trouble speaking. Seek help immediately.',
  'medicine': 'Please specify the medicine name for more information.',
  'symptom': 'Please specify your symptom for more details.',
  'diet': 'A balanced diet includes fruits, vegetables, proteins, and whole grains.',
  'exercise': 'Regular exercise helps maintain good health.',
  'weight loss': 'For weight loss, eat healthy and exercise regularly.',
  'depression': 'Depression is a serious condition. Talk to someone you trust or a professional.',
  'anxiety': 'Anxiety can be managed with relaxation techniques and support.',
  'doctor': 'It is always best to consult a doctor for medical advice.',
  'emergency': 'In case of emergency, call your local emergency number immediately.',
  // ... (rest of the 500+ keywords and responses as previously provided) ...
};

String getBotResponse(String userInput) {
  userInput = userInput.toLowerCase();
  for (final entry in botResponses.entries) {
    if (userInput.contains(entry.key)) {
      return entry.value;
    }
  }
  return 'Sorry, I do not have information about that. Please ask about common diseases, medicines, or say hello!';
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      String botReply = getBotResponse(text);
      _messages.add({'sender': 'bot', 'text': botReply});
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Chatbot',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['sender'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isUser ? const Color(0xFF1856B6) : const Color(0xFFAEE9C7),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        msg['text'] ?? '',
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF1856B6),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
} 