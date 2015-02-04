##AsyncImages##

This project provides a streamlined interface for loading remote images into UIImageViews.  The extension implemented allows an image view to be populated from a URL string seamlessly in one line:

    image.setImageWithURLString(imageURLString)

The demo project uses the Instagram API for example content - to run the project you will need to provide an Instagram client id.  This client id needs to be set within ViewController.swift on the following line:

    let kClientId = "INSTAGRAM_CLIENT_ID"

where INSTAGRAM_CLIENT_ID should be replaced with a valid client id, which can be retrieved from the instagram developer portal: [http://instagram.com/developer/](http://instagram.com/developer/)
