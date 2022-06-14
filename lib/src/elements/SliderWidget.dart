import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/src/models/slider.dart';

SliderWidget(double height,List<SliderModel> sliders) {
  return Container(
    child: CarouselSlider.builder(
        options: CarouselOptions(
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlay: false,
          aspectRatio: 3 / 2,
          height: height * 0.25,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          // onPageChanged: callbackFunction,
          scrollDirection: Axis.horizontal,
        ),
        itemCount: sliders.length,
        itemBuilder: (BuildContext context, itemIndex) {
          return Container(
            height: height * 0.25,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                       sliders[itemIndex].url),
                    fit: BoxFit.fill),
              ),
            ),
          );
        }),
  );
}