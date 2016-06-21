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
        // ParseObject.registerSubclass(Message.class);
        // ParseObject.registerSubclass(Post.class);
        ParseObject.registerSubclass(Schools.class);
        // Existing initialization happens after all classes are registered

        // set applicationId and server
        // any network interceptors must be added with the Configuration Builder given this syntax
        Parse.initialize(new Parse.Configuration.Builder(this)
                .applicationId("hKmxGJE5hCHKaJzo6gLaHiTA0rHP4LLfaU3glM5w") // should correspond to APP_ID env variable
                .clientKey("eaRPKYGEroESs0JFj1LrJImfjCVEKyJTZUb9orj3")
                .addNetworkInterceptor(new ParseLogInterceptor()).build());
                //.server("https://wec2017android.herokuapp.com/parse/").build());
        //ParseUser.enableAutomaticUser();
        //ParseACL defaultAcl = new ParseACL();

    }
}
