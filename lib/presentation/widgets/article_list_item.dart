import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/article.dart';

class ArticleListItem extends StatelessWidget {
  final Article item;
  final VoidCallback onTap;

  const ArticleListItem({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 100,
                  height: 80,
                  child: item.urlToImage != null
                      ? CachedNetworkImage(
                    imageUrl: item.urlToImage!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image_outlined,
                          color: Colors.grey, size: 40),
                    ),
                  )
                      : Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image_outlined,
                        color: Colors.grey, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (item.queryTag != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.queryTag!,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        const Spacer(),
                        if (item.publishedAt != null)
                          Text(
                            DateUtilsX.toHuman(item.publishedAt!),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
