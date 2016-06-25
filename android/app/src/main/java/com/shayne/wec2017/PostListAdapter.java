package com.shayne.wec2017;

import android.content.ClipData;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

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

            if (tvPost != null) {
                tvPost.setText(post.get("info").toString());
            }
            if (tvDate != null) {
                tvDate.setText(df.format(post.getCreatedAt()));
            }
        }

        return v;
    }

}
