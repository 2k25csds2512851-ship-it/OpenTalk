import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../features/feed/models/post_model.dart';

class StanceCard extends StatefulWidget {
  final StancePostModel post;
  final VoidCallback? onDebateTap;

  const StanceCard({super.key, required this.post, this.onDebateTap});

  @override
  State<StanceCard> createState() => _StanceCardState();
}

class _StanceCardState extends State<StanceCard> {
  bool hasUpvoted = false;
  bool hasDownvoted = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author header
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF6366F1),
                  child: Text(
                    post.authorName.isNotEmpty ? post.authorName[0] : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '#${post.topic}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF818CF8),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Text(
                    'Verified',
                    style: TextStyle(
                      color: Color(0xFF34D399),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Title & Content
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFCBD5E1),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            // Action row
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_up_alt_outlined,
                    size: 18,
                    color: hasUpvoted ? const Color(0xFF10B981) : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      hasUpvoted = !hasUpvoted;
                      if (hasUpvoted) {
                        post.upvotes++;
                        if (hasDownvoted) {
                          hasDownvoted = false;
                          post.downvotes--;
                        }
                      } else {
                        post.upvotes--;
                      }
                    });
                  },
                ),
                Text(
                  '${post.upvotes}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.thumb_down_alt_outlined,
                    size: 18,
                    color: hasDownvoted ? const Color(0xFFEF4444) : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      hasDownvoted = !hasDownvoted;
                      if (hasDownvoted) {
                        post.downvotes++;
                        if (hasUpvoted) {
                          hasUpvoted = false;
                          post.upvotes--;
                        }
                      } else {
                        post.downvotes--;
                      }
                    });
                  },
                ),
                Text(
                  '${post.downvotes}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.share_outlined, size: 18, color: Colors.grey),
                  tooltip: 'Share',
                  onPressed: () async {
                    final link = 'https://opentalk.app/post/${post.id}';
                    await Clipboard.setData(ClipboardData(text: link));
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Link copied to clipboard!'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF1F2937),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                InkWell(
                  onTap: widget.onDebateTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.mode_comment_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${post.replyCount} Debates',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
