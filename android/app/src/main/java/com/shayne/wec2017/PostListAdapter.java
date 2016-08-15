package com.shayne.wec2017;

import android.content.ClipData;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.text.Html;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.parse.GetDataCallback;
import com.parse.ParseException;
import com.parse.ParseFile;
import com.parse.ParseUser;
import com.squareup.picasso.Picasso;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Created by Shayne on 2016-06-21.
 */

public class PostListAdapter extends ArrayAdapter<Posts> {

    DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss", Locale.CANADA);

    public PostListAdapter(Context context, int textViewResourceId) {
        super(context, textViewResourceId);
    }

    public PostListAdapter(Context context, int resource, List<Posts> items) {
        super(context, resource, items);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        View v = convertView;

        if (v == null) {
            LayoutInflater layoutInflater;
            layoutInflater = LayoutInflater.from(getContext());
            v = layoutInflater.inflate(R.layout.post_list_item, null);
        }

        Posts post = getItem(position);

        if (post != null) {
            TextView tvPost = (TextView) v.findViewById(R.id.post_content);
            TextView tvDate = (TextView) v.findViewById(R.id.post_date);
            TextView tvAuthor = (TextView) v.findViewById(R.id.post_author);
            final ImageView ivImage = (ImageView) v.findViewById(R.id.post_img);
            StringBuilder author;

            if (tvPost != null) {
                tvPost.setText(post.get("info").toString());
            }
            if (tvDate != null) {
                tvDate.setText(formatTime(post.getCreatedAt()));
            }
            if (tvAuthor != null) {
                ParseUser user = post.getParseUser("user");
                try {
                    user.fetch();
                }
                catch (ParseException e) {
                    e.printStackTrace();
                }

                if (user.get("fullname") != null) {
                    author = new StringBuilder("<b>" + user.get("fullname").toString() + "</b>");
                }
                else {
                    author = new StringBuilder(user.get("username").toString());
                }
                if (user.get("school") != null) {
                    author.append("  - " + user.get("school").toString());
                }

                tvAuthor.setText(Html.fromHtml(author.toString()));
            }
            if (ivImage != null) {
                if ((Boolean)post.get("hasImage")) {
                    Picasso.with(getContext()).load(post.getParseFile("image").getUrl()).into(ivImage);
                }
                else
                {
                    ivImage.setImageBitmap(null);
                }
            }
        }

        return v;
    }

    private String formatTime(Date postDate) {
        Date currentDate = new Date();

        long currentTime = currentDate.getTime() / 1000;
        long postTime = postDate.getTime() / 1000;

        if (currentTime >= postTime) {
            long difference = currentTime - postTime;

            if (difference < 60) {
                String string = Long.toString(difference) + " seconds ago";
                return string;
            }
            else if (difference >= 60 && difference < 60*60) {
                String string = Long.toString(difference/60) + " minutes ago";
                return string;
            }
            else if (difference >= 60*60 && difference < 60*60*24) {
                String string = Long.toString(difference/(60*60)) + " hours ago";
                return string;
            }
            else if (difference >= 60*60*24) {
                String string = Long.toString(difference/(60*60*24)) + " days ago";
                return string;
            }
        }

        return "Some time ago";
    }
}
