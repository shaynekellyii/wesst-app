package com.shayne.wec2017;


import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;

    import com.parse.FindCallback;
    import com.parse.Parse;
    import com.parse.ParseException;
    import com.parse.ParseObject;
    import com.parse.ParseQuery;

    import java.util.ArrayList;
    import java.util.List;

    /**
     * Created by Shayne on 2016-06-21.
     */
    public class SchoolFragment extends android.support.v4.app.ListFragment {
        List<String> schools;
        ArrayAdapter<String> adapter;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState) {
        schools = new ArrayList<String>();
        getListOfSchools();

        adapter = new ArrayAdapter<String>(inflater.getContext(),
                android.R.layout.simple_list_item_1, schools);
        setListAdapter(adapter);

        return super.onCreateView(inflater, container, savedInstanceState);
    }

    private void getListOfSchools() {
        ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("Schools");
        query.findInBackground(new FindCallback<ParseObject>() {
            @Override
            public void done(List<ParseObject> objects, ParseException e) {
                for (ParseObject schoolObject : objects) {
                    schools.add(schoolObject.get("name").toString());
                }
                if (schools.size() > 0 && adapter != null) {
                    adapter.notifyDataSetChanged();
                }
            }
        });
    }
}
