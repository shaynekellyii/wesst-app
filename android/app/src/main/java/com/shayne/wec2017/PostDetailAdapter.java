package com.shayne.wec2017;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

/**
 * Created by Shayne on 2016-06-24.
 */
public class PostDetailAdapter extends ArrayAdapter<Comment> {
    DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss", Locale.CANADA);

    public PostDetailAdapter(Context context, int textViewResourceId) {
        super(context, textViewResourceId);
    }

    public PostDetailAdapter(Context context, int resource, List<Comment> items) {
        super(context, resource, items);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View v = convertView;

        if (v == null) {
            LayoutInflater layoutInflater;
            layoutInflater = LayoutInflater.from(getContext());
            v = layoutInflater.inflate(R.layout.comment_list_item, null);
        }

        Comment comment = getItem(position);

        if (comment != null) {
            TextView tvContent = (TextView) v.findViewById(R.id.tvCommentContent);
            TextView tvDate = (TextView) v.findViewById(R.id.tvCommentDate);

            if (tvContent != null) {
                tvContent.setText(comment.getContent());
            }
            if (tvDate != null) {
                tvDate.setText(df.format(comment.getDate()));
            }
        }

        return v;
    }
}
