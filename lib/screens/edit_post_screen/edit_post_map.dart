import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:eviks_mobile/icons.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../models/post.dart';
import '../../models/settlement.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_input.dart';
import './step_title.dart';

class EditPostMap extends StatefulWidget {
  final Post post;
  final Function updatePost;

  const EditPostMap({
    required this.post,
    required this.updatePost,
    Key? key,
  }) : super(key: key);

  @override
  _EditPostMapState createState() => _EditPostMapState();
}

class _EditPostMapState extends State<EditPostMap> {
  final _formKey = GlobalKey<FormState>();

  late MapController _mapController;
  late StreamSubscription _subscription;

  List<double> _location = [49.8786270618439, 40.379108951404];
  String _city = '';
  String _district = '';
  String _subdistrict = '';
  String _address = '';
  var _isLoading = false;

  final _controller = TextEditingController();

  @override
  void initState() {
    _mapController = MapController();
    _subscription =
        _mapController.mapEventStream.listen((MapEvent mapEvent) async {
      if (mapEvent is MapEventMoveEnd) {
        setState(() {
          _isLoading = true;
        });

        String _errorMessage = '';
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        try {
          final response = await Provider.of<Posts>(context, listen: false)
              .getAddressByCoords({
            'lng': 'az',
            'x': _mapController.center.longitude,
            'y': _mapController.center.latitude,
          });

          setState(() {
            _location = [
              _mapController.center.latitude,
              _mapController.center.longitude,
            ];
            _city = response['city'] ?? '';
            _district = response['district'] ?? '';
            _subdistrict = response['subdistrict'] ?? '';
            _address = response['address'] ?? '';
            _controller.value = TextEditingValue(text: _address);
          });
        } on Failure catch (error) {
          if (error.statusCode >= 500) {
            _errorMessage = AppLocalizations.of(context)!.serverError;
          } else {
            _errorMessage = error.toString();
          }
        } catch (error) {
          _errorMessage = AppLocalizations.of(context)!.unknownError;
        }

        if (_errorMessage.isNotEmpty) {
          displayErrorMessage(context, _errorMessage);
        }

        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _continuePressed() {
    widget.updatePost(widget.post.copyWith(
      city: Settlement(id: '', name: _city),
      district: Settlement(id: '', name: _district),
      subdistrict: Settlement(id: '', name: _subdistrict),
      address: _address,
      step: 2,
    ));
  }

  void _prevStep() {
    widget.updatePost(widget.post.copyWith(
      step: 0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(_location[1], _location[0]),
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    'http://maps.gomap.az/info/xyz.do?lng=az&x={x}&y={y}&z={z}&f=jpg'),
          ],
        ),
        Center(
          child: SvgPicture.asset(
            "assets/img/svg/location.svg",
            width: 60.0,
            height: 60.0,
          ),
        ),
        SizedBox(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(
                            50.0,
                          ),
                          bottomLeft: Radius.circular(
                            50.0,
                          )),
                    ),
                    child: Column(children: [
                      StepTitle(
                        title: AppLocalizations.of(context)!.address,
                        icon: CustomIcons.marker,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 8.0),
                        child: StyledInput(
                          icon: CustomIcons.marker,
                          keyboardType: TextInputType.text,
                          controller: _controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.errorAddress;
                            }
                          },
                          onSaved: (value) {
                            _address = value ?? '';
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      width: SizeConfig.safeBlockHorizontal * 50,
                      height: 60.0,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _continuePressed,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Theme.of(context).primaryColor;
                              } else {
                                return Theme.of(context).primaryColor;
                              }
                            },
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 24.0,
                                height: 24.0,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).backgroundColor,
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)!.next,
                                style: TextStyle(
                                  color: Theme.of(context).backgroundColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      width: SizeConfig.safeBlockHorizontal * 50,
                      height: 60.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).backgroundColor)),
                        onPressed: _prevStep,
                        child: Text(
                          AppLocalizations.of(context)!.back,
                          style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
