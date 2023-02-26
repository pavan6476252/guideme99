import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

getCachedNetworkImage(String url,BoxShape boxShape){
  return CachedNetworkImage(
    imageBuilder: (context, imageProvider) => Container(
  
    decoration: BoxDecoration(

      shape: boxShape,
      image: DecorationImage(
        image: imageProvider,),
    ),
  ),
    
    imageUrl: url,
    placeholder: (context, url) => const CircularProgressIndicator(),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}
