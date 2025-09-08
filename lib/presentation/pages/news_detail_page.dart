import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/date_utils.dart';
import '../../domain/entities/article.dart';

class NewsDetailPage extends StatelessWidget {
  final Article article;
  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.queryTag ?? "Article")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(imageUrl: article.urlToImage!),
              ),
            const SizedBox(height: 12),
            Text(article.title ?? "", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                if (article.sourceName != null)
                  Text(article.sourceName!, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(width: 12),
                if (article.author != null)
                  Text("by ${article.author!}", style: Theme.of(context).textTheme.labelMedium),
                const Spacer(),
                if (article.publishedAt != null)
                  Text(DateUtilsX.toHuman(article.publishedAt!), style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: 16),
            if ((article.content ?? "").isNotEmpty)
              Text(article.content!, style: Theme.of(context).textTheme.bodyMedium)
            else if ((article.description ?? "").isNotEmpty)
              Text(article.description!, style: Theme.of(context).textTheme.bodyMedium)
            else
              Text("No content available.", style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            if ((article.url ?? "").isNotEmpty)
              FilledButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(article.url!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text("Open original"),
              ),
          ],
        ),
      ),
    );
  }
}

