import 'package:anilist_manga/screen/ova_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class MangaListScreen extends StatefulWidget {
  const MangaListScreen({super.key});

  @override
  MangaListScreenState createState() => MangaListScreenState();
}

class MangaListScreenState extends State<MangaListScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MangaProvider>(context, listen: false).fetchManga();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mangaProvider = Provider.of<MangaProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My Manga'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 117, 112, 112),
        elevation: 0,
      ),
      body: mangaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(text: 'Top Rated'),
                      Tab(text: 'OVA'),
                      Tab(text: 'Genres'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildMangaGrid(mangaProvider.mangaList), // Top Rated
                        _buildOvaGrid(mangaProvider.mangaList), // OVA Content
                        _buildGenresView(), // Genres
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const <IconData>[
          Icons.home,
          Icons.refresh,
          Icons.search,
        ],
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.end,
        onTap: _onItemTapped,
        notchSmoothness: NotchSmoothness.defaultEdge,
        backgroundColor: Colors.grey[900],
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
      ),
    );
  }

  Widget _buildMangaGrid(List<dynamic> mangaList) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final manga = mangaList[index];
                return _buildMangaCard(manga);
              },
              childCount: mangaList.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOvaGrid(List<dynamic> mangaList) {
    final ovaList = mangaList.where((manga) => manga['type'] == 'OVA').toList();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final ova = ovaList[index];
                return _buildMangaCard(ova);
              },
              childCount: ovaList.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenresView() {
    return const Center(
      child: Text(
        'Genres Feature Coming Soon!',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  Widget _buildMangaCard(dynamic manga) {
    return Card(
      elevation: 10,
      shadowColor: Colors.black54,
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                manga['images']['jpg']['image_url'] ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[700],
                    child: const Center(
                      child: Text(
                        'Image not available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              manga['title'] ?? 'Unknown Title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
