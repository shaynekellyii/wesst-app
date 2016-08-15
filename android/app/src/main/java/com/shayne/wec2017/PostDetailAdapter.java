package com.shayne.wec2017;

import android.content.Context;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.parse.ParseException;
import com.parse.ParseUser;

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
        ViewHolder holder = new ViewHolder();

        if (v == null) {
            LayoutInflater layoutInflater;
            layoutInflater = LayoutInflater.from(getContext());
            v = layoutInflater.inflate(R.layout.comment_list_item, null);
        }

        holder.tvContent = (TextView) v.findViewById(R.id.tvCommentContent);
        holder.tvDate = (TextView) v.findViewById(R.id.tvCommentDate);
        holder.tvAuthor = (TextView) v.findViewById(R.id.tvCommentAuthor);

        Comment comment = getItem(position);

        if (comment != null) {
            if (holder.tvContent != null) {
                holder.tvContent.setText(comment.getContent());
            }
            if (holder.tvDate != null) {
                holder.tvDate.setText(df.format(comment.getDate()));
            }
            if (holder.tvAuthor != null) {
                holder.tvAuthor.setText(comment.getAuthor());
            }
        }

        return v;
    }

    static class ViewHolder {
        TextView tvContent;
        TextView tvDate;
        TextView tvAuthor;
    }
}
