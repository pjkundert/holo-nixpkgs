import tmp from "tmp";
import request from "request";
import url from "url";
import fs from "fs";

// Download from url to tmp file
// return tmp file path
export const downloadFile = async (downloadUrl) => {
    console.log("Downloading url: ", downloadUrl);
    const fileName = tmp.tmpNameSync();
    let file = fs.createWriteStream(fileName);

    // Clean up url
    let urlObj = new URL(downloadUrl);
    urlObj.protocol = "https";
    downloadUrl = urlObj.toString();

    return new Promise((resolve, reject) => {
        let stream = request({
            uri: downloadUrl
        })
        .pipe(file)
        .on('finish', () => {
            //console.log(`Downloaded file from ${downloadUrl} to ${fileName}`);
            resolve(fileName);
        })
        .on('error', (error) => {
            reject(error);
        })
    })
}

export const parsePreferences = (preferences, provider_pubkey) => {
  const mtbi = JSON.parse(preferences.max_time_before_invoice)
  return {
    max_fuel_before_invoice: parseInt(preferences.max_fuel_before_invoice),
    max_time_before_invoice: [parseInt(mtbi[0]), parseInt(mtbi[1])],
    price_compute: parseInt(preferences.price_compute),
    price_storage: parseInt(preferences.price_storage),
    price_bandwidth: parseInt(preferences.price_bandwidth),
    provider_pubkey
  }
}
