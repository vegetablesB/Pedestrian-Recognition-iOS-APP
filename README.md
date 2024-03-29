# Pedestrian-Recognition-iOS-APP
This is an iOS APP for Pedestrian Recongition.

[Backend based on Django](https://github.com/vegetablesB/Pedestrian-Recognition-Backend-Django)

![representation](https://github.com/vegetablesB/Pedestrian-Recognition-iOS-APP/blob/main/ezgif.com-gif-maker-3.gif)

## Table of Contents

- [Background](#background)
- [Design](#design)
- [TODO](#todo)
- [Contributing](#contributing)
- [License](#license)

## Background
Computer Vision is a popular field and has a plenty of applications such as AI and autonomous vehicles. The pedestrian detection one of the most fundamental procedures in developing controlling packages of self-driving vehicles. We designed an Apple Universal app by which user can upload their own photos to our algorithm and get it back with marked people in this picture through backend to frontend.

[New backend based on Django](https://github.com/vegetablesB/Pedestrian-Recognition-Backend-Django)

- The new backend is based on Django with full User function including create user, Auth.

- The new backend is developed with Django and Django REST framework which come with RESTful API and fulled produciton feature.

- With this backend, the iOS app will upload image as file without change to base64.

[Old backend based on flask](https://github.com/vegetablesB/Pedestrian-Recognition-Backend)

- Based on Flask.

## Design
The picture shown above is how the user uses the software. The front end has three main parts. First is the original part with importing images from the camera and photo library. 

The second part is to communicate with the server. 
After the user clicks the post button, the photo will be encoded as a base 64 string and sent to the server. Then the software will get a predicated picture as a base 64 string and the corresponded name created by the server. The post function will decode the photo string and save the corresponded name. Then show the photo result on the screen.
After the user clicks the Finish button after drawing, the post function will send JSON data to the server, including a modified photo as a base 64 string, photo name, and customized rectangle information.

The last part is drawing rectangles using fingers. 
As you can see from the result shown in the second part, only two people were selected, but three people were in the photo. Because there is a plastic curtain between the people and the camera, it is challenging for the algorithm to detect people. The user would like to draw the selection by themselves in this situation. The picture shown below is the drawing part. After the user presses the finish button, the result will be shown on the screen and sent to the server.

![representation](https://github.com/vegetablesB/Pedestrian-Recognition-iOS-APP/blob/main/ezgif.com-gif-maker-2.gif)


## TODO

- The user function comes with Django, we can add new user related part in future.
- With more detailed model in Django, we can add a lot of new features including add description to each time runing a model.



## Contributing
[@vegetablesB](https://github.com/vegetablesB)

## License
[MIT © Richard McRichface.](../LICENSE)


