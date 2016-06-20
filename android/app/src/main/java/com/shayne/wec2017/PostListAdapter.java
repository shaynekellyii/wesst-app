package com.shayne.wec2017;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

/**
 * Created by Shayne on 2016-06-07.
 */
public class PostListAdapter extends ArrayAdapter<Post> {
    private Context context;
    String mUserId;

    public PostListAdapter(Context context, String userId, List<Post> posts) {
        super(context, android.R.layout.simple_list_item_1, posts);
        this.context = context;
        this.mUserId = userId;
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        Post post = (Post)getItem(position);
        View viewToUse = null;

        // Block to support grid view or list view
        LayoutInflater mInflater = (LayoutInflater)context.getSystemService(Activity.LAYOUT_INFLATER_SERVICE);
        if (convertView == null) {
            viewToUse = mInflater.inflate(R.layout.post_list_item, null);
            holder = new ViewHolder();
            holder.tvPost = (TextView)viewToUse.findViewById(R.id.post_content_view);
            holder.tvUser = (TextView)viewToUse.findViewById(R.id.post_user_view);
        }
        else {
            viewToUse = convertView;
            holder = (ViewHolder)viewToUse.getTag();
        }

        holder.tvPost.setText(post.getBody());
        holder.tvUser.setText(post.getUserId());

        return viewToUse;
    }

    // Holder for the list items
    private class ViewHolder {
        public TextView tvPost;
        public TextView tvUser;
    }
}
