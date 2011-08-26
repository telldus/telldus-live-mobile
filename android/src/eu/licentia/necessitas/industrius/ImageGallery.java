package eu.licentia.necessitas.industrius;

import android.util.Log;
import android.app.Activity;
import android.content.Intent;
import android.os.Message;
import android.os.Bundle;
import android.content.Context;
import android.database.Cursor;
import android.provider.MediaStore;
import android.net.Uri;

import eu.licentia.necessitas.industrius.QtApplication;

public class ImageGallery extends Activity{

	private final static int pickerRequestCode = 42;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		QtActivity currentActivity = QtApplication.mainActivity();
		//Intent intent = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI); //alternative way
		Intent intent = new Intent();
		intent.setType("image/*");
		intent.setAction(Intent.ACTION_GET_CONTENT);
		startActivityForResult(Intent.createChooser(intent, "Pick a program to select a Layout Background from"), pickerRequestCode);
	}

	@Override
	 public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		if(requestCode == pickerRequestCode){

			String filePath = "";
			if(resultCode == RESULT_OK){
				Uri selectedImage = data.getData();
				String[] filePathColumn = {MediaStore.Images.Media.DATA};

				Cursor cursor = QtApplication.mainActivity().getContentResolver().query(selectedImage, filePathColumn, null, null, null);
				if(cursor != null){
					if(cursor.moveToFirst()){
						int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
						Log.i("Telldus", "Prepending file://...");
						filePath = "file://" + cursor.getString(columnIndex);
						Log.i("Telldus", "FILE: " + filePath);
					}
					cursor.close();
				}
				else{
					//different image pickers are obviously returning different things... this seems to work when using QuickPic...
					Log.i("Telldus", "No first in cursor, no prepending!");
					Log.i("Telldus", "FILE (2): " + selectedImage);
					filePath = selectedImage.toString();
				}
			}
			pickedImage(filePath);
			finish();
		}
	}

	public static native void pickedImage(String imageurl);

	public static void pickImage(){
		QtActivity currentActivity = QtApplication.mainActivity();
		Intent intent = new Intent(currentActivity, eu.licentia.necessitas.industrius.ImageGallery.class);
		currentActivity.startActivity(intent);
	}
}
