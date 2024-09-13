import 'package:fix_mates_user/bloc/Search/bloc/search_bloc.dart';
import 'package:fix_mates_user/bloc/Search/bloc/search_event.dart';
import 'package:fix_mates_user/bloc/Search/bloc/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_mates_user/view/booking_screens/worker_details_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  final List<Map<String, String?>> gridItems = const [
    {
      'image': 'assets/electric.png',
      'title': 'Electrical',
      'category': 'Electrical'
    },
    {'image': 'assets/fridge.png', 'title': 'Fridge', 'category': 'Fridge'},
    {
      'image': 'assets/ac.png',
      'title': 'Air condition',
      'category': 'Air condition'
    },
    {
      'image': 'assets/handyman.png',
      'title': 'Handyman',
      'category': 'Handyman'
    },
    {'image': 'assets/mop.png', 'title': 'Cleaning', 'category': 'Cleaning'},
    {
      'image': 'assets/plumbing.png',
      'title': 'Plumbing',
      'category': 'Plumbing'
    },
    {
      'image': 'assets/wm.png',
      'title': 'Washing Machine',
      'category': 'Washing Machine'
    },
    {
      'image': 'assets/painting.png',
      'title': 'Painting',
      'category': 'Painting'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return TextField(
                autofocus: true,
                onChanged: (value) {
                  context.read<SearchBloc>().add(UpdateSearchQuery(value));
                },
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                style: TextStyle(color: Colors.black87, fontSize: 16),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              final filteredItems = gridItems.where((item) {
                final titleLower = item['title']?.toLowerCase() ?? '';
                final searchLower = state.query.toLowerCase();
                return titleLower.contains(searchLower);
              }).toList();

              return filteredItems.isNotEmpty
                  ? ListView.separated(
                      itemCount: filteredItems.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceProvidersScreen(
                                    category: item['category']!),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    item['image']!,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    item['title']!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey[400], size: 18),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No services found.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
