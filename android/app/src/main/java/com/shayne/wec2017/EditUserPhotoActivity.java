package com.shayne.wec2017;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import com.parse.ParseException;
import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.SaveCallback;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Shayne on 2016-07-13.
 */
public class EditUserPhotoActivity extends AppCompatActivity {
    Bitmap bitmap;

    ImageView imageView;
    Button btSave;
    ParseUser user;

    private static final int SELECT_PHOTO_REQ_CODE = 100;
    private static final int REQUEST_CODE_ASK_PERMISSIONS = 123;
    private static final int MAX_IMG_DIM = 600;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_user_photo);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        imageView = (ImageView)findViewById(R.id.ivProfileImgPreview);
        btSave = (Button)findViewById(R.id.btSaveImage);
        user = ParseUser.getCurrentUser();

        int hasPermission = ContextCompat.checkSelfPermission(EditUserPhotoActivity.this,
                Manifest.permission.READ_EXTERNAL_STORAGE);
        if (hasPermission != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(EditUserPhotoActivity.this,
                    new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},
                    REQUEST_CODE_ASK_PERMISSIONS);
            return;
        }

        btSave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                user.saveInBackground();
                finish();
            }
        });

        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        startActivityForResult(intent, SELECT_PHOTO_REQ_CODE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == SELECT_PHOTO_REQ_CODE && resultCode == Activity.RESULT_OK) {
            try {
                if (bitmap != null) {
                    bitmap.recycle();
                }
                InputStream stream = getContentResolver().openInputStream(data.getData());
                bitmap = BitmapFactory.decodeStream(stream);
                stream.close();

                packImageForParse();
                imageView.setImageBitmap(bitmap);
            }
            catch (FileNotFoundException e) {
                e.printStackTrace();
            }
            catch (IOException e) {
                e.printStackTrace();
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void packImageForParse() {
        int resizeCoeff = 1;

        assert bitmap != null;
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();

        // Resize image to match Parse limitations
        if (width > MAX_IMG_DIM || height > MAX_IMG_DIM) {
            if (width > height) {
                resizeCoeff = width / MAX_IMG_DIM;
            }
            else {
                resizeCoeff = height / MAX_IMG_DIM;
            }
            width /= resizeCoeff;
            height /= resizeCoeff;
            bitmap = Bitmap.createScaledBitmap(bitmap, width, height, false);
        }

        // Convert to jpg (required format for our ParseFile)
        try {
            ByteArrayOutputStream outStream = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, outStream);
            byte[] imgData = outStream.toByteArray();
            outStream.flush();
            outStream.close();

            // Add image to current user
            ParseFile imgFile = new ParseFile("picture.jpg", imgData);
            user.put("picture", imgFile);
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case REQUEST_CODE_ASK_PERMISSIONS: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Intent photoPickerIntent = new Intent(Intent.ACTION_PICK,
                            MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                    photoPickerIntent.setType("image/*");
                    startActivityForResult(photoPickerIntent, SELECT_PHOTO_REQ_CODE);

                }
                else {
                    Snackbar.make(findViewById(R.id.edit_user_photo_content),
                            "Please grant permission to file system to add a photo",
                            Snackbar.LENGTH_LONG).show();
                }
                return;
            }
        }
    }
}
