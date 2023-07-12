import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:griot_app/accounts/presentation/bloc/beloved_ones_bloc_bloc.dart';
import 'package:griot_app/core/presentation/pages/base_page.dart';
import 'package:griot_app/core/presentation/widgets/griot_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class BelovedOnesListPage extends StatefulWidget {
  const BelovedOnesListPage({super.key});

  @override
  State<BelovedOnesListPage> createState() => _BelovedOnesListPageState();
}

class _BelovedOnesListPageState extends State<BelovedOnesListPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BelovedOnesBlocBloc>(context)
        .add(GetBelovedOnesListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Scaffold(
        appBar: const GriotAppBar(
          automaticallyImplyLeading: false,
          title: 'Beloved Ones',
        ),
        body: BlocBuilder<BelovedOnesBlocBloc, BelovedOnesBlocState>(
          builder: (context, state) {
            if (state is BelovedOnesBlocLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is BelovedOnesBlocSuccess) {
              if (state.belovedOnesList.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: state.belovedOnesList.length,
                    itemBuilder: (context, index) {
                      final beloved = state.belovedOnesList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x071d1617),
                                blurRadius: 40,
                                offset: Offset(0, 10), // Position of shadow
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: beloved.profilePicture != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          beloved.profilePicture!,
                                        ),
                                        radius: 25,
                                      )
                                    : Container(),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${beloved.name ?? ''}${beloved.middleName != null ? ' ${beloved.middleName!}' : ''}${beloved.lastName != null ? ' ${beloved.lastName}' : ''}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      beloved.name ?? 'nops',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFADA4A5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Padding(
                  padding:
                      const EdgeInsets.all(45.0), // Add padding to the Column
                  child: Center(
                    // Align Column in the center of the screen
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Align Column items in the center of the column
                      children: [
                        const Spacer(flex: 2), // Add space before first Text
                        Text(
                          'Looks like you didn\'t add any beloved one yet.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Spacer(flex: 4), // Add space before first Text
                        Text(
                          'Here will be the list of all friends and family that you share your memories with',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(flex: 4), // Add space before first Text
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              launchUrl(Uri.parse(
                                  'https://wa.me/5521975015593?text=Olá!%0aComo%20posso%20adicionar%20um%20novo%20Beloved%20One%20à%20minha%20conta?'));
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xff51ac87),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(99.0),
                              ),
                            ),
                            child: SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Want to invite a Beloved One?',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 10), // Add space after the Button
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
