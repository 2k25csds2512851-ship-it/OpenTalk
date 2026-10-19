import 'package:flutter/material.dart';
import '../../shared/widgets/debate_bottom_sheet.dart';
import '../feed/models/post_model.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  final List<String> tags = const [
    'monorepo',
    'flutter',
    'open-source',
    'campus',
    'ux',
    'career',
    'firebase',
    'sprint2026',
  ];

  List<Map<String, dynamic>> trending = const [
    {'title': 'Serverless Cloud Functions vs Microservices', 'score': 98, 'count': 240, 'topic': 'tech'},
    {'title': 'GDGOC Open Source Sprint 2026 Kickoff', 'score': 95, 'count': 180, 'topic': 'open-source'},
    {'title': 'Flutter Web Performance vs Next.js', 'score': 89, 'count': 145, 'topic': 'tech'},
    {'title': 'How to pick your first Good First Issue', 'score': 82, 'count': 92, 'topic': 'open-source'},
  ];

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    setState(() {
      trending = [
        for (final t in trending)
          {...t, 'score': ((t['score'] as int) + 1).clamp(0, 100)},
      ]..sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    });
  }

  StancePostModel _asPost(Map<String, dynamic> t, int index) {
    final now = DateTime.now();
    return StancePostModel(
      id: 'trend-$index',
      authorId: 'user-1',
      authorName: 'Trending',
      title: t['title'] as String,
      content: 'Live metrics: ${t['count']} stances • velocity score ${t['score']}%.',
      topic: t['topic'] as String? ?? 'general',
      tags: const [],
      upvotes: t['count'] as int,
      downvotes: 0,
      replyCount: (t['count'] as int) ~/ 10,
      moderationStatus: 'approved',
      createdAt: now,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending Debates', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final tag = tags[i];
                  return ActionChip(
                    label: Text(tag, style: const TextStyle(fontSize: 12)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Filtering by #$tag (live metrics coming soon)')),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            for (var index = 0; index < trending.length; index++)
              Builder(
                builder: (context) {
                  final t = trending[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Text(
                        '0${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFF818CF8),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      title: Text(
                        t['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      subtitle: Text(
                        '${t['count']} stances • ${t['score']}% activity',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => DebateBottomSheet(post: _asPost(t, index)),
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
