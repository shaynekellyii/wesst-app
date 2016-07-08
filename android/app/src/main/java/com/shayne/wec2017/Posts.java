package com.shayne.wec2017;

import android.graphics.Bitmap;
import android.media.Image;

import com.parse.ParseClassName;
import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseUser;

import java.util.Date;

/**
 * Created by Shayne on 2016-06-07.
 */

    @ParseClassName("Posts")
    public class Posts extends ParseObject {
    public static String getInfo() {
        return info;
    }

        public static String info;
        public static Bitmap imgBitmap;
        public static ParseUser user;
        public static int replies;
        public static String[] comments;
        public static Date[] commentsDate;
        public static ParseUser[] commentsUsers;
        public boolean hasImage;
    }
