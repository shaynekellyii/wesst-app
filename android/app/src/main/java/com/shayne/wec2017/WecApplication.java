package com.shayne.wec2017;

import android.app.Application;

import com.parse.Parse;
import com.parse.ParseACL;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.interceptors.ParseLogInterceptor;

/**
 * Created by Shayne on 2016-06-01.
 */
public class WecApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();

        // Register your parse models here
        ParseObject.registerSubclass(Message.class);
        ParseObject.registerSubclass(Post.class);
        // Existing initialization happens after all classes are registered

        // set applicationId and server based on the values in the Heroku settings.
        // any network interceptors must be added with the Configuration Builder given this syntax
        Parse.initialize(new Parse.Configuration.Builder(this)
                .applicationId("wec2017android") // should correspond to APP_ID env variable
                .addNetworkInterceptor(new ParseLogInterceptor())
                .server("https://wec2017android.herokuapp.com/parse/").build());
        ParseUser.enableAutomaticUser();
        ParseACL defaultAcl = new ParseACL();

    }
}
