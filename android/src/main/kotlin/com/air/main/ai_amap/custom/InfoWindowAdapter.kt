package com.air.main.ai_amap.custom

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.air.main.ai_amap.R
import com.amap.api.maps.AMap
import com.amap.api.maps.model.Marker


/**
 * <p>
 * @author air on 2020.
 * </p>
 */
class InfoWindowAdapter(context: Context) : AMap.InfoWindowAdapter, View.OnClickListener {

    private val mContext: Context = context;
    private var mMarker: Marker? = null
    private var mInfoWindow: View = TextView(mContext);
    private lateinit var mConfirmListener: OnConfirmListener;

    override fun getInfoContents(marker: Marker?): View {
        mInfoWindow = LayoutInflater.from(mContext).inflate(R.layout.map_info_window, null);
        if (marker != null) {
            render(marker = marker, view = mInfoWindow);
        }
        return mInfoWindow;
    }

    override fun getInfoWindow(marker: Marker?): View {
        /*
        Use custom marker's info window.
         */

        mInfoWindow = LayoutInflater.from(mContext).inflate(R.layout.map_info_window, null);
        if (marker != null) {
            render(marker = marker, view = mInfoWindow);
        }

        return mInfoWindow;
    }


    /**
     * 自定义infoWindow窗口
     */
    private fun render(marker: Marker, view: View) {
        //如果想修改自定义InfoWindow中内容，请通过view找到它并修改
        mMarker = marker;
        val titleTv: TextView = view.findViewById(R.id.title_tv);
        val contentTv: TextView = view.findViewById(R.id.content_tv);

        //show info
        titleTv.text = marker.title;
        contentTv.text = marker.snippet;

//        mInfoWindowModel = convertToModel(marker.getSnippet());

        //取其中一位
//        var titleString: String = TextUtils.isEmpty(mInfoWindowModel.getTitle()) ? mInfoWindowModel.getDate() : mInfoWindowModel.getTitle();


        val naviGroup: View = view.findViewById(R.id.navi_group);
        val detailGroup: View = view.findViewById(R.id.detail_group);
        val closeImg: ImageView = view.findViewById(R.id.close_img);


        naviGroup.setOnClickListener(this);
        detailGroup.setOnClickListener(this);
        closeImg.setOnClickListener(this);

//        if (mInfoWindowModel.isShowCancel()) {
//            detailGroup.setVisibility(View.VISIBLE);
//        } else {
//            detailGroup.setVisibility(View.GONE);
//        }
//
//        if (mInfoWindowModel.isShowDetail()) {
//            naviGroup.setVisibility(View.VISIBLE);
//        } else {
//            naviGroup.setVisibility(View.GONE);
//
//        }
//        if (mInfoWindowModel.isShowClose()) {
//            closeImg.setVisibility(View.VISIBLE);
//        } else {
//            closeImg.setVisibility(View.GONE);
//        }
    }

    override fun onClick(v: View?) {

        val id = v!!.id

        when (id) {
            R.id.navi_group -> {
                mConfirmListener
                        .confirm(mMarker);
            }
            R.id.detail_group -> {
                //do something
            }
            R.id.close_img -> mMarker?.hideInfoWindow()
        }
    }

    interface OnConfirmListener {
        fun confirm(marker: Marker?)
    }

    fun setOnConfirmListener(onConfirmListener: OnConfirmListener) {
        mConfirmListener = onConfirmListener
    }
}