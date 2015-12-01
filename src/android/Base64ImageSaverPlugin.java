package org.solderzzc.Base64ImageSaverPlugin;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Calendar;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;

import org.json.JSONArray;
import org.json.JSONException;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.util.Base64;
import android.util.Log;

/**
 * Base64ImageSaverPlugin.java
 *
 * Android implementation of the Base64ImageSaverPlugin for iOS.
 * Inspirated by Joseph's "Save HTML5 Canvas Image to Gallery" plugin
 * http://jbkflex.wordpress.com/2013/06/19/save-html5-canvas-image-to-gallery-phonegap-android-plugin/
 *
 * @author Vegard Løkken <vegard@headspin.no>
 */
/**
 * Canvas2ImagePlugin.java
 *
 * Android implementation of the Canvas2ImagePlugin for iOS.
 * Inspirated by Joseph's "Save HTML5 Canvas Image to Gallery" plugin
 * http://jbkflex.wordpress.com/2013/06/19/save-html5-canvas-image-to-gallery-phonegap-android-plugin/
 *
 * @author Vegard Løkken <vegard@headspin.no>
 */
public class Base64ImageSaverPlugin extends CordovaPlugin {
    public static final String ACTION = "saveImageDataToLibrary";

    @Override
    public boolean execute(String action, final JSONArray data,
            final CallbackContext callbackContext) throws JSONException {

        if (action.equals(ACTION)) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    new SaveImageTask(callbackContext).execute(data.optString(0));
                }
            });
        }
        return true;
    }
    
    /* Invoke the system's media scanner to add your photo to the Media Provider's database, 
     * making it available in the Android Gallery application and to other apps. */
    private void scanPhoto(File imageFile)
    {
        Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
        Uri contentUri = Uri.fromFile(imageFile);
        mediaScanIntent.setData(contentUri);                  
        cordova.getActivity().sendBroadcast(mediaScanIntent);
    }

    class SaveImageTask extends AsyncTask<String, String, File> {

        private CallbackContext context;

        public SaveImageTask(CallbackContext context) {
            this.context = context;
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            System.out.println("!!!!!!!  ON PRE");
        }

        @Override
        protected File doInBackground(String... params) {
            if ("".equals(params[0])) {
                context.error("Base64 empty");
                return null;
            }

            File retVal = null;

            byte[] decodedString = Base64.decode(params[0], Base64.DEFAULT);
            Bitmap bmp = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
            if (bmp == null) {
                context.error("The image could not be decoded");
            } else {

                try {
                    Calendar c = Calendar.getInstance();
                    String date = "" + c.get(Calendar.DAY_OF_MONTH)
                            + c.get(Calendar.MONTH)
                            + c.get(Calendar.YEAR)
                            + c.get(Calendar.HOUR_OF_DAY)
                            + c.get(Calendar.MINUTE)
                            + c.get(Calendar.SECOND);

                    String deviceVersion = Build.VERSION.RELEASE;
                    Log.i("Base64ImageSaverPlugin", "Android version " + deviceVersion);
                    int check = deviceVersion.compareTo("2.3.3");

                    File folder;

                    if (check >= 1) {
                        folder = Environment
                                .getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);

                        if (!folder.exists()) {
                            folder.mkdirs();
                        }
                    } else {
                        folder = Environment.getExternalStorageDirectory();
                    }

                    File imageFile = new File(folder, "c2i_" + date.toString() + ".jpg");

                    FileOutputStream out = new FileOutputStream(imageFile);
                    bmp.compress(Bitmap.CompressFormat.PNG, 100, out);
                    out.flush();
                    out.close();

                    retVal = imageFile;
                } catch (Exception e) {
                    Log.e("Base64ImageSaverPlugin", "An exception occured while saving image: "
                            + e.toString());
                }
            }

            System.out.println("!!!!EXECUTE ");
            return retVal;
        }

        @Override
        protected void onPostExecute(File result) {
            super.onPostExecute(result);
            System.out.println("!!!!! ON POST");
            if (result != null) {
                scanPhoto(result);
                context.success(result.toString());
            } else context.error("Error while saving image");
        }
    }
}