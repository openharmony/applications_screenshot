/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Log from '../../../../../../../../common/src/main/ets/default/Log.ets'
import ScreenshotManager from '@ohos.screenshot';
import WindowMar  from '@ohos.window'
import ImageMar from '@ohos.multimedia.image'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import FileIo from '@ohos.fileio';
import Constants from '../common/constants.ets'
import display from '@ohos.display'

const TAG = 'ScreenShot-ScreenShotModel';

const SAVE_IMAGE_DELAY = 500;
const OPTIONS_QUALITY = 100;

export class ScreenShotModel {
  captureImage: any = null;
  imageFilename: string = '';

  shotScreen() {
    Log.showInfo(TAG, `shotScreen`)
    ScreenshotManager.save().then(async (data) => {
      Log.showInfo(TAG, `ScreenshotManager.save data:${JSON.stringify(data)}`)
      if (!!data) {
        this.captureImage = data;
        AppStorage.Set("captureImage", data);
        this.saveImage(this.captureImage, {
          format: ["image/jpeg"], quality: OPTIONS_QUALITY
        });
      }
    }).catch((err) => {
      Log.showInfo(TAG, `ScreenshotManager.save err:${JSON.stringify(err)}`)
    })
  }

  async saveImage(pixelMap, options) {
    const media = mediaLibrary.getMediaLibrary(globalThis.shotScreenContext);
    Log.showInfo(TAG, `saveImage options:${JSON.stringify(options)}`);
    this.imageFilename = (new Date()).getTime() + '.jpg';
    var packer = ImageMar.createImagePacker();
    Log.showInfo(TAG, `saveImage packer:${JSON.stringify(packer)}`);
    this.showWindow();
    await new Promise((resolve) => setTimeout(resolve, SAVE_IMAGE_DELAY))
    packer.packingFromPixelMap(pixelMap, options).then((jpegData) => {
      Log.showInfo(TAG, `packing jpegData type:` + jpegData.constructor.name + '  value : ' + jpegData);
      media.getPublicDirectory(mediaLibrary.DirectoryType.DIR_IMAGE, (err, rp) => {
        if (rp != undefined) {
          Log.showInfo(TAG, `getPublicDirectory successfull:${JSON.stringify(rp)}`);
          media.createAsset(mediaLibrary.MediaType.IMAGE, this.imageFilename, rp, (createAssetErr, fileAsset) => {
            if (fileAsset != undefined) {
              Log.showInfo(TAG, `createAsset successfull:${JSON.stringify(fileAsset.uri)}`);
              fileAsset.open('Rw').then((fd) => {
                if (fd == undefined) {
                  Log.showInfo(TAG, `fileAsset open fail`);
                  return;
                }
                Log.showInfo(TAG, `open successful, fd = ${JSON.stringify(fd)}`);
                FileIo.write(fd, jpegData).then(num => {
                  Log.showInfo(TAG, `FileIo write, num = ${JSON.stringify(num)}`);
                  fileAsset.close(fd).then(() => {
                    Log.showInfo(TAG, `FileIo close,successfull`);
                  })
                });
              });
            } else {
              Log.showInfo(TAG, `createAsset fail`);
            }
          })
        } else {
          Log.showInfo(TAG, `getPublicDirectory fail`);
        }
      })
    });
  }

  showWindow() {
    Log.showInfo(TAG, `showWindow`);
    WindowMar.find(Constants.WIN_NAME).then((win) => {
      win.show(() => {
        Log.showInfo(TAG, `window show`);
      })
    })

  }

  dismiss(): void  {
    Log.showInfo(TAG, 'dismiss');
    //close ability
    globalThis.shotScreenContext.terminateSelf((err, data) => {
      Log.showInfo(TAG, `terminateSelf finish err:${err} data:${JSON.stringify(data)}`)
      WindowMar.find(Constants.WIN_NAME).then((win) => {
        win.destroy(() => {
          Log.showInfo(TAG, `destroy the window finish`);
        })
      })
    })
  }

  openAbility(wantData) {
    Log.showInfo(TAG, `openAbility want:${JSON.stringify(wantData)}`);
    globalThis.shotScreenContext.startAbility(wantData)
  }
}

let screenShotModel = new ScreenShotModel();

export default screenShotModel as ScreenShotModel