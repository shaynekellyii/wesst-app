package com.shayne.wec2017;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v4.graphics.drawable.RoundedBitmapDrawable;
import android.support.v4.graphics.drawable.RoundedBitmapDrawableFactory;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.parse.ParseUser;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

/**
 * Created by Shayne on 2016-06-21.
 */

public class ProfileFragment extends Fragment {

    TextView tvName;
    TextView tvSchool;
    TextView tvTitle;
    TextView tvAbout;
    TextView tvYear;
    TextView tvDiscipline;
    TextView tvGender;
    TextView tvPhone;
    TextView tvEmail;
    TextView tvBday;
    ImageButton ibPhoto;
    Button btEditProfile;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_profile, container, false);

        tvName = (TextView)rootView.findViewById(R.id.user_profile_name);
        tvTitle = (TextView)rootView.findViewById(R.id.user_profile_title);
        tvSchool = (TextView)rootView.findViewById(R.id.user_profile_school);
        tvAbout = (TextView)rootView.findViewById(R.id.user_profile_about);
        tvYear = (TextView)rootView.findViewById(R.id.user_profile_year);
        tvDiscipline = (TextView)rootView.findViewById(R.id.user_profile_discipline);
        tvGender = (TextView)rootView.findViewById(R.id.user_profile_gender);
        tvPhone = (TextView)rootView.findViewById(R.id.user_profile_phone);
        tvEmail = (TextView)rootView.findViewById(R.id.user_profile_email);
        tvBday = (TextView)rootView.findViewById(R.id.user_profile_birthday);
        ibPhoto = (ImageButton)rootView.findViewById(R.id.user_profile_photo);

        /*btEditProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getActivity(), EditProfileActivity.class);
                startActivity(intent);
            }
        });*/

        return rootView;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        populateProfile();
    }

    @Override
    public void onResume() {
        super.onResume();
        populateProfile();
    }

    private void populateProfile() {
        ParseUser user = ParseUser.getCurrentUser();
        if (user != null) {
            if (user.get("fullname") != null) {
                tvName.setText(user.get("fullname").toString());
            }
            else {
                tvName.setText(R.string.not_specified);
            }

            if (user.get("school") != null) {
                tvSchool.setText(user.get("school").toString());
            }
            else {
                tvSchool.setText(R.string.not_specified);
            }

            if (user.get("title") != null) {
                tvTitle.setText(user.get("title").toString());
            }
            else {
                tvTitle.setText(R.string.not_specified);
            }

            if (user.getEmail() != null) {
                tvEmail.setText("Email\n" + user.getEmail());
            }
            else {
                tvTitle.setText("Email\n" + getResources().getString(R.string.not_specified));
            }

            if (user.get("gender") != null) {
                tvGender.setText("Gender\n" + user.get("gender").toString());
            }
            else {
                tvGender.setText("Gender\n" + getResources().getString(R.string.not_specified));
            }

            if (user.get("info") != null) {
                tvAbout.setText("About\n" + user.get("info").toString());
            }
            else {
                tvAbout.setText("About\n" + getResources().getString(R.string.not_specified));
            }

            if (user.get("phone") != null) {
                tvPhone.setText("Phone number\n" + user.get("phone").toString());
            }
            else {
                tvPhone.setText("Phone number\n" + getResources().getString(R.string.not_specified));
            }

            if (user.get("option") != null) {
                tvDiscipline.setText("Discipline\n" + user.get("option").toString());
            }
            else {
                tvDiscipline.setText("Discipline\n" + getResources().getString(R.string.not_specified));
            }

            if (user.get("year") != null) {
                tvYear.setText("Year\n" + user.get("year").toString());
            }
            else {
                tvYear.setText("Year\n" + getResources().getString(R.string.not_specified));
            }

            if (user.get("birthday") != null) {
                tvBday.setText("Birthday\n" + user.get("birthday").toString());
            }
            else {
                tvBday.setText("Birthday\n" + getResources().getString(R.string.not_specified));
            }

            if (user.get("picture") != null) {
                Picasso.with(getContext()).load(user.getParseFile("picture").getUrl()).into(ibPhoto, new Callback() {
                    @Override
                    public void onSuccess() {
                        Bitmap bitmap = ((BitmapDrawable) ibPhoto.getDrawable()).getBitmap();
                        bitmap = Bitmap.createScaledBitmap(bitmap, 400, 400, false);

                        RoundedBitmapDrawable roundDrawable = RoundedBitmapDrawableFactory.create(getResources(), bitmap);
                        roundDrawable.setCircular(true);

                        ibPhoto.setImageDrawable(roundDrawable);
                    }
                    @Override
                    public void onError() {
                        // yikes...
                    }
                });
            }
        }
    }
}