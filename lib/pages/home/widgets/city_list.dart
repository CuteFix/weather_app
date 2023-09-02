import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/const/app_colors.dart';
import 'package:weather_app/const/app_style.dart';
import 'package:weather_app/core/blocs/home/home_bloc.dart';
import 'package:weather_app/models/city_data.dart';

class CityList extends StatefulWidget {
  final List<LocationData> cityList;
  final TextEditingController cityController;
  final double paddingTop;

  const CityList(
      {super.key, required this.cityList, required this.cityController, required this.paddingTop});

  @override
  State<CityList> createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (widget.cityList.length * 50),
      width: (MediaQuery.of(context).size.width - 102),
      child: ListView.separated(
        padding: EdgeInsets.only(top: widget.paddingTop),
        itemCount: widget.cityList.length,
        itemBuilder: (context, index) {
          final isLastItem = index == widget.cityList.length - 1;

          final border = Border(
            bottom: BorderSide(
              color: isLastItem ? Colors.transparent : AppColors.white2Color,
              width: isLastItem ? 0.0 : 1.0,
            ),
          );

          Widget item = InkWell(
            onTap: () {
              _selectCity(
                  '${widget.cityList[index].name ?? ' '},${widget.cityList[index].country ?? ''}',
                  widget.cityController);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white2Color,
                border: border,
              ),
              height: 40,
              width: double.infinity,
              child: Center(
                // Center the content horizontally
                child: ListTile(
                  title: Column(
                    children: [
                      Text(
                        '${widget.cityList[index].name ?? ' '},${widget.cityList[index].country}',
                        style: AppStyle.textStyleButton(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          if (isLastItem) {
            // Wrap the last item with ClipRRect to create a circular border
            item = ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
              child: item,
            );
          }

          return item;
        },
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.greyColor,
        ),
      ),
    );
  }

  void _selectCity(String city, TextEditingController cityController) {
    context.read<HomeBloc>().add(GetWeatherCityName(city));
    setState(() {
      cityController.text = city;
    });
  }
}
