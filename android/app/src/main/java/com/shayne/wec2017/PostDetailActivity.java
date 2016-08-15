package com.shayne.wec2017;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.Html;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.parse.FindCallback;
import com.parse.GetDataCallback;
import com.parse.ParseException;
import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;
import com.parse.SaveCallback;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Created by Shayne on 2016-06-22.
 */
public class PostDetailActivity extends AppCompatActivity {
    ListView listView;
    DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss", Locale.CANADA);
    TextView tvPostAuthor;
    TextView tvPostDate;
    TextView tvPostContent;
    List<Comment> comments;
    Comment comment;
    PostDetailAdapter adapter;
    Button btComment;
    EditText etComment;
    Posts post;
    List<String> authors;
    int numComments;
    int numAuthorsLeft;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Inflate layout
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_post_detail);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        // Setup comment listview and adapter
        comments = new ArrayList<>();
        listView = (ListView)findViewById(android.R.id.list);
        adapter = new PostDetailAdapter(this, R.layout.post_list_item, comments);
        listView.setAdapter(adapter);

        // Get post id and populate post view
        Intent intent = getIntent();
        String id = intent.getStringExtra("id");
        tvPostAuthor = (TextView)findViewById(R.id.tvPostAuthor);
        tvPostDate = (TextView)findViewById(R.id.tvPostDate);
        tvPostContent = (TextView)findViewById(R.id.tvPostContent);
        assert tvPostAuthor != null;
        tvPostAuthor.setText("Loading...");
        fetchPost(id);

        // Set listener to post comment
        btComment = (Button)findViewById(R.id.btComment);
        btComment.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                sendComment();
            }
        });
    }

    private void sendComment() {
        etComment = (EditText)findViewById(R.id.etComment);
        ParseUser user = ParseUser.getCurrentUser();
        if (post != null && !etComment.getText().toString().matches("")) {
            post.add("comments", etComment.getText().toString());
            post.add("commentsDate", new Date());
            post.add("commentsUser", user);
            post.increment("replies");

            post.saveInBackground(new SaveCallback() {
                @Override
                public void done(ParseException e) {
                    if (e == null) {
                        Snackbar.make(findViewById(R.id.post_detail_activity), "Comment sent", Snackbar.LENGTH_SHORT).show();
                    } else {
                        Log.e("Comment didn't save", e.toString());
                    }
                }
            });
        }
        else {
            Snackbar.make(findViewById(R.id.post_detail_activity), "Please add content to your comment", Snackbar.LENGTH_SHORT).show();
        }
    }

    private void fetchPost(String id) {
        ParseQuery<Posts> query = ParseQuery.getQuery("Posts");
        query.whereEqualTo("objectId", id);
        query.findInBackground(new FindCallback<Posts>() {
            @Override
            public void done(List<Posts> objects, ParseException e) {
                if (e == null) {
                    post = objects.get(0);
                    getPostAuthor(post);
                    try {
                        packageComments(post);
                    }
                    catch (Exception jsonException) {
                        // oops
                    }
                } else {
                    // error
                }
            }
        });
    }

    private void getPostAuthor(final Posts post) {
        StringBuilder author;

        ParseUser user = post.getParseUser("user");
        try {
            user.fetch();
        }
        catch (ParseException e) {
            // oops
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
        tvPostAuthor.setText(Html.fromHtml(author.toString()));

        fillPost(post);

        if ((Boolean)post.get("hasImage")) {
            fillImage(post);
        }
    }

    private void fillPost(Posts post) {
        assert tvPostContent != null;
        tvPostContent.setText(post.get("info").toString());
        assert tvPostDate != null;
        tvPostDate.setText(formatTime(post.getCreatedAt()));
    }

    private void fillImage(Posts post) {
        ParseFile imageFile = (ParseFile)post.get("image");
        imageFile.getDataInBackground(new GetDataCallback() {
            @Override
            public void done(byte[] data, ParseException e) {
                if (e == null) {
                    Bitmap bmp = BitmapFactory.decodeByteArray(data, 0, data.length);
                    ImageView imageView = (ImageView) findViewById(R.id.ivPostDetail);
                    assert imageView != null;
                    imageView.setImageBitmap(bmp);
                    imageView.setPadding(0, 0, 0, 24);
                } else {
                    Log.e("PostDetailActivity", "Problem loading image from Parse");
                }
            }
        });
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

    private void packageComments(Posts post) throws JSONException {
        List<String> contentList = post.getList("comments");
        List<Date> contentDate = post.getList("commentsDate");
        JSONArray commentAuthor = post.getJSONArray("commentsUser");
        authors = new ArrayList<>();

        if (contentList.size() > 0) {
            for (int i = 0; i < contentList.size(); i++) {
                JSONObject jsonAuthor = commentAuthor.getJSONObject(i);
                String author = jsonAuthor.getString("objectId");
                    ParseQuery<ParseObject> query = ParseQuery.getQuery("_User"); // .include() method
                    query.whereEqualTo("objectId", author);
                    try {
                        ParseUser user = (ParseUser)query.getFirst();
                        user.fetch();
                        authors.add(user.get("fullname").toString());
                    }
                    catch (ParseException e) {
                        Log.e("Comments", e.getMessage());
                    }

                Comment comment = new Comment();
                comment.setContent(contentList.get(i));
                comment.setDate(contentDate.get(i));
                comment.setAuthor(authors.get(i));
                comments.add(comment);
            }
        }

        if (comments.size() > 0 && adapter != null) {
            adapter.notifyDataSetChanged();
        }
    }
}
