import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  Color _backgroundColor = Colors.white;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _todoList = [];
  TextEditingController _controller = TextEditingController();
  bool isPlaying = false;

  final List<Color> _colors = [
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.brown
  ];
  int _colorIndex = 0;

  void _changeBackgroundColor(int direction) {
    if (_selectedIndex == 1) {
      // Only change background in "Change Background" tab
      setState(() {
        _colorIndex = (_colorIndex + direction) % _colors.length;
        if (_colorIndex < 0) {
          _colorIndex = _colors.length - 1;
        }
        _backgroundColor = _colors[_colorIndex];
      });
    }
  }

  void _playAudio() async {
    if (!isPlaying) {
      await _audioPlayer.play(AssetSource('audio/sound.mp3'));
      setState(() {
        isPlaying = true;
      });
    } else {
      await _audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    }
  }

  void _addTodo(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoList.add(task);
        _controller.clear();
      });
    }
  }

  Widget _buildTodoList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter task',
              border: OutlineInputBorder(),
            ),
            onSubmitted: _addTodo,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _todoList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_todoList[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: _selectedIndex == 1
            ? _backgroundColor
            : Colors.white, // Background changes only in tab 2
        appBar: AppBar(title: const Text('Flutter App')),
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              _changeBackgroundColor(-1); // Swipe Right
            } else if (details.primaryVelocity! < 0) {
              _changeBackgroundColor(1); // Swipe Left
            }
          },
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              _changeBackgroundColor(-1); // Swipe Down
            } else if (details.primaryVelocity! < 0) {
              _changeBackgroundColor(1); // Swipe Up
            }
          },
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildTodoList(),
              Center(
                child: ElevatedButton(
                  onPressed: () => _changeBackgroundColor(1),
                  child: const Text('Change Background Color'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _playAudio,
                  child: Text(isPlaying ? 'Stop Audio' : 'Play Audio'),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), label: 'To-Do List'),
            BottomNavigationBarItem(
                icon: Icon(Icons.color_lens), label: 'Change Background'),
            BottomNavigationBarItem(
                icon: Icon(Icons.audiotrack), label: 'Audio Player'),
          ],
        ),
      ),
    );
  }
}
