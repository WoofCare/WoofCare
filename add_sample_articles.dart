import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// Quick script to add sample articles to Firebase
/// Run with: dart run add_sample_articles.dart

void main() async {
  print('Initializing Firebase...');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  print('Connected to Firestore!\n');

  // Sample articles to add
  final articles = [
    {
      'title': 'How To Approach A Stray Dog',
      'category': 'Guide',
      'author': 'Voice of Stray Dogs',
      'date': Timestamp.now(),
      'imageUrl':
          'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400',
      'content':
          'When approaching a stray dog, it\'s important to remain calm and move slowly. Never make direct eye contact or sudden movements. Crouch down to appear less threatening and extend your hand slowly for the dog to sniff. If the dog shows signs of aggression, back away slowly without turning your back.',
    },
    {
      'title': 'How To Recognize Rabies In Dogs',
      'category': 'Medical',
      'author': 'Voice of Stray Dogs',
      'date': Timestamp.now(),
      'imageUrl':
          'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?w=400',
      'content':
          'Rabies is a serious viral disease. Common symptoms include excessive drooling, difficulty swallowing, aggressive behavior, disorientation, and paralysis. If you encounter a dog showing these signs, maintain distance and contact animal control immediately. Never attempt to handle a potentially rabid animal.',
    },
    {
      'title': 'The Inspirational Story Of Hachi',
      'category': 'Stories',
      'author': 'Voice of Stray Dogs',
      'date': Timestamp.now(),
      'imageUrl':
          'https://images.unsplash.com/photo-1568572933382-74d440642117?w=400',
      'content':
          'Hachi was an Akita dog who became famous for his unwavering loyalty. Every day, he would wait at Shibuya Station for his owner to return from work. Even after his owner passed away, Hachi continued to wait at the station for nearly 10 years. His story exemplifies the incredible bond between humans and dogs.',
    },
    {
      'title': 'Essential Vaccinations For Street Dogs',
      'category': 'Medical',
      'author': 'Voice of Stray Dogs',
      'date': Timestamp.now(),
      'imageUrl':
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=400',
      'content':
          'Street dogs need protection from diseases like rabies, distemper, and parvovirus. Community vaccination programs are essential for public health and animal welfare. Core vaccines should be administered by qualified veterinarians. Regular vaccination drives help control disease spread in stray populations.',
    },
    {
      'title': 'Understanding Dog Body Language',
      'category': 'Guide',
      'author': 'Voice of Stray Dogs',
      'date': Timestamp.now(),
      'imageUrl':
          'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400',
      'content':
          'Dogs communicate primarily through body language. A wagging tail doesn\'t always mean friendly - look at the whole body. Relaxed posture, soft eyes, and gentle tail wags indicate friendliness. Stiff body, direct stare, raised hackles, and bared teeth signal warning. Understanding these signs keeps you safe.',
    },
    {
      'title': 'The Journey Of A Rescue Dog',
      'category': 'Stories',
      'author': 'Voice of Stray Dogs',
      'date': Timestamp.now(),
      'imageUrl':
          'https://images.unsplash.com/photo-1477884213360-7e9d7dcc1e48?w=400',
      'content':
          'Max was found abandoned on the streets, malnourished and scared. After rescue by a local shelter, he received medical care, proper nutrition, and most importantly, love. Today, Max has found his forever home and brings joy to his family every day. Every rescue dog has a story worth sharing.',
    },
  ];

  print('Adding ${articles.length} sample articles...\n');

  int count = 0;
  for (final article in articles) {
    try {
      await firestore.collection('articles').add(article);
      count++;
      print('✓ Added: ${article['title']}');
    } catch (e) {
      print('✗ Error adding ${article['title']}: $e');
    }
  }

  print('\n${'=' * 50}');
  print('Successfully added $count/${articles.length} articles!');
  print('${'=' * 50}');
  print('\nArticles are now live in your app. Check the Articles page!');
}