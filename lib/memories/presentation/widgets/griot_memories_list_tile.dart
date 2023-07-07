import 'package:flutter/material.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';

class GriotMemoryListTile extends StatelessWidget {
  final Memory memory;

  const GriotMemoryListTile({Key? key, required this.memory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/memories_manipulation_page',
            arguments: memory,
          );
        },
        child: Container(
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Color(0x071d1617),
                blurRadius: 40,
                offset: Offset(0, 10), // Position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.play_arrow,
                color: Colors.green,
              ),
              const SizedBox(
                  width: 8.0), // give some space between the icon and title
              Expanded(
                child: Text(
                  memory.title ?? 'Unnamed Memory',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${memory.videos?.length ?? 0} files',
                style: const TextStyle(
                  color: Color(0xFFa4a9ad),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  fontSize: 10.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
