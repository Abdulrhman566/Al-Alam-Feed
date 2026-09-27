import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_api_session/constants/app_api.dart';
import 'package:new_api_session/models/news_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Main news list
  List newslist = [];
  List<newsmodel> NewModelList = [];

  // Top headlines list
  List topNewsList = [];

  String query = "cars";

  bool isLoading = true;
  bool isTopNewsLoading = true;

  String? errorMessage;

  final TextEditingController searchController = TextEditingController();

  // =========================
  // Get Main News
  // =========================
  Future<void> getnewadata() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          "${AppApi.baseurl}everything?q=$query&apiKey=${AppApi.apikey}",
        ),
      );

      if (response.statusCode == 200) {
        final news = jsonDecode(response.body);

        setState(() {
          newslist = news["articles"] ?? [];

          NewModelList = newslist
              .map((article) => newsmodel.fromJson(article))
              .toList();

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Failed to load news";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Something went wrong";
      });
    }
  }

  // =========================
  // Get Top Headlines
  // =========================
  Future<void> getTopNews() async {
    setState(() {
      isTopNewsLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          "${AppApi.baseurl}top-headlines?country=us&apiKey=${AppApi.apikey}",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          topNewsList = data["articles"] ?? [];
          isTopNewsLoading = false;
        });
      } else {
        setState(() {
          isTopNewsLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isTopNewsLoading = false;
      });
    }
  }

  // =========================
  // Init State
  // =========================
  @override
  void initState() {
    super.initState();

    getnewadata();
    getTopNews();
  }

  // =========================
  // Dispose
  // =========================
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // =========================
  // Open Article
  // =========================
  Future<void> openArticle(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // =========================
  // Build
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F4FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        centerTitle: false,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "News",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            Text(
              "Stay updated with the latest news",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              getnewadata();
              getTopNews();
            },
            icon: const Icon(Icons.refresh),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 15),

              child: TextField(
                controller: searchController,

                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() {
                      query = value.trim();
                    });

                    getnewadata();
                  }
                },

                decoration: InputDecoration(
                  hintText: "Search news...",

                  prefixIcon: const Icon(Icons.search, color: Colors.purple),

                  suffixIcon: IconButton(
                    onPressed: () {
                      if (searchController.text.trim().isNotEmpty) {
                        setState(() {
                          query = searchController.text.trim();
                        });

                        getnewadata();
                      }
                    },

                    icon: const Icon(Icons.arrow_forward),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Colors.purple,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // =========================
          // TOP HEADLINES TITLE
          // =========================
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),

              child: Text(
                "Top Headlines",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // =========================
          // HORIZONTAL NEWS
          // =========================
          SliverToBoxAdapter(child: _buildTopNews()),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // =========================
          // LATEST NEWS TITLE
          // =========================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Row(
                children: [
                  const Text(
                    "Latest News",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      query,
                      style: const TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          // =========================
          // MAIN NEWS LIST
          // =========================
          if (isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Colors.purple),
              ),
            )
          else if (NewModelList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  "No news found",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 20),

              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final article = NewModelList[index];

                  return _newsCard(
                    title: article.title ?? "No Title",

                    description:
                        article.description ?? "No description available.",

                    imageUrl: article.urlToImage,

                    articleUrl: article.url ?? "",
                  );
                }, childCount: NewModelList.length),
              ),
            ),
        ],
      ),
    );
  }

  // =========================
  // Top Headlines Horizontal List
  // =========================
  Widget _buildTopNews() {
    if (isTopNewsLoading) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator(color: Colors.purple)),
      );
    }

    if (topNewsList.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.symmetric(horizontal: 16),

        itemCount: topNewsList.length,

        itemBuilder: (context, index) {
          final article = topNewsList[index];

          final title = article["title"] ?? "No title";
          final imageUrl = article["urlToImage"];
          final url = article["url"];

          return GestureDetector(
            onTap: () async {
              if (url != null) {
                await openArticle(url);
              }
            },

            child: Container(
              width: 300,
              margin: const EdgeInsets.only(right: 15),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),

                child: Stack(
                  children: [
                    Positioned.fill(
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,

                              errorBuilder: (context, error, stackTrace) {
                                return _imagePlaceholder();
                              },
                            )
                          : _imagePlaceholder(),
                    ),

                    // Dark gradient
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,

                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(.85),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Title
                    Positioned(
                      left: 15,
                      right: 15,
                      bottom: 15,

                      child: Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // =========================
  // Main News List
  // =========================
  Widget _buildNewsList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.purple),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.cloud_off, size: 70, color: Colors.grey),

            const SizedBox(height: 15),

            Text(
              errorMessage!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: getnewadata,

              icon: const Icon(Icons.refresh),

              label: const Text("Try Again"),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (newslist.isEmpty) {
      return const Center(
        child: Text(
          "No news found",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      color: Colors.purple,

      onRefresh: getnewadata,

      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(16, 5, 16, 20),

        itemCount: newslist.length,

        itemBuilder: (context, index) {
          final title = NewModelList[index].title ?? "No Title";

          final description =
              NewModelList[index].description ?? "No description available.";

          final imageUrl = NewModelList[index].urlToImage;

          final articleUrl = NewModelList[index].url ?? "";

          return _newsCard(
            title: title,
            description: description,
            imageUrl: imageUrl,
            articleUrl: articleUrl,
          );
        },
      ),
    );
  }

  // =========================
  // News Card
  // =========================
  Widget _newsCard({
    required String title,
    required String description,
    required String? imageUrl,
    required String articleUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),

            child: SizedBox(
              height: 210,
              width: double.infinity,

              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stackTrace) {
                        return _imagePlaceholder();
                      },
                    )
                  : _imagePlaceholder(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Source
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(.1),

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Text(
                        "NEWS",
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Spacer(),

                    const Icon(Icons.access_time, size: 15, color: Colors.grey),

                    const SizedBox(width: 4),

                    const Text(
                      "Today",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Title
                Text(
                  title,

                  maxLines: 3,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 10),

                // Description
                Text(
                  description,

                  maxLines: 3,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 15),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: articleUrl.isEmpty
                            ? null
                            : () => openArticle(articleUrl),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,

                          elevation: 0,

                          padding: const EdgeInsets.symmetric(vertical: 13),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(Icons.article_outlined, size: 18),

                            SizedBox(width: 7),

                            Text(
                              "Read Article",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(.1),

                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: IconButton(
                        onPressed: articleUrl.isEmpty
                            ? null
                            : () async {
                                await SharePlus.instance.share(
                                  ShareParams(uri: Uri.parse(articleUrl)),
                                );
                              },

                        icon: const Icon(
                          Icons.share_outlined,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Image Placeholder
  // =========================
  Widget _imagePlaceholder() {
    return Container(
      color: Colors.purple.withOpacity(.08),

      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 55,
          color: Colors.purple,
        ),
      ),
    );
  }
}
