package com.shayne.wec2017;

import com.parse.ParseUser;

import java.util.Date;

/**
 * Created by Shayne on 2016-06-24.
 */

public class Comment {
    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    private String author;

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    private String content;

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    private Date date;

    /*public Comment(String content, Date date, String author) {
        this.author = author;
        this.content = content;
        this.date = date;
    }*/
}
