package com.shayne.wec2017;

import android.media.Image;

import com.parse.ParseClassName;
import com.parse.ParseObject;
import com.parse.ParseUser;

import java.util.Date;

/**
 * Created by Shayne on 2016-06-07.
 */

    @ParseClassName("Posts")
    public class Posts extends ParseObject {
        public static String info;
        public static Image image;
        public static ParseUser user;
        public static int replies;
        public static String[] comments;
        public static Date[] commentsDate;
        public static ParseUser[] commentsUsers;
        public boolean hasImage;
    }
