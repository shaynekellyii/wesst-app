package com.shayne.wec2017;

import com.parse.ParseClassName;
import com.parse.ParseObject;

/**
 * Created by Shayne on 2016-06-21.
 */
@ParseClassName("Schools")
public class Schools extends ParseObject {
    public static String name;

    public String getName() {
        return name;
    }
}
