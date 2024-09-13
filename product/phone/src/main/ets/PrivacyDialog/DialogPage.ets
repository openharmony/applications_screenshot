/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import Log from '../../../../../../common/src/main/ets/default/Log';
import Want from '@ohos.app.ability.Want';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import measure from '@ohos.measure';
import display from '@ohos.display'

const TAG = 'AVScreenCapture-DiaLogPage';

@CustomDialog
struct PrivacyWindowDialog {
  cancel?: () => void;
  confirm?: () => void;
  controller: CustomDialogController;
  appLabel: string = '';
  overflow: boolean = false;

  build() {
    Column() {
      if (this.overflow) {
        Row() {
          Text($r('app.string.avscreencapture_privacy_window_title'))
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .width('100%')
            .textOverflow({ overflow: TextOverflow.Ellipsis})
            .maxLines(2)
            .fontSize(16)
        }
        .alignItems(VerticalAlign.Center)
        .padding({ top: 16, bottom: 16 })
        .margin({ left: 24, right: 24})
      } else {
        Row() {
          Text($r('app.string.avscreencapture_privacy_window_title'))
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .width('100%')
            .fontSize($r('sys.float.ohos_id_text_size_headline8'))
        }
        .alignItems(VerticalAlign.Center)
        .margin({ left: 24, right: 24 })
        .height(56)
      }

      Column() {
        Text($r('app.string.avscreencapture_privacy_window_content', this.appLabel))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .width('100%')
      }
      .margin({ left: 24, right: 24 })

      Flex({ justifyContent: FlexAlign.SpaceAround}) {
        Column() {
          Button($r('app.string.avscreencapture_privacy_window_cancel'), { type: ButtonType.Capsule })
            .onClick(() => {
              this.controller.close();
              if (this.cancel) {
                this.cancel();
              }
            })
            .backgroundColor(Color.Transparent)
            .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
            .fontSize($r('sys.float.ohos_id_text_size_button1'))
            .width('100%')
            .height('100%')
        }
        .width('100%')

        Column() {
          Column()
            .backgroundColor($r('sys.color.ohos_id_color_list_separator'))
            .height(24)
            .width(1)
        }
        .margin({ left: 2, right: 2, top: 8 })
        .justifyContent(FlexAlign.Center)

        Column() {
          Button($r('app.string.avscreencapture_privacy_window_agree'), { type: ButtonType.Capsule })
            .onClick(() => {
              this.controller.close();
              if (this.confirm) {
                this.confirm();
              }
            })
            .backgroundColor(Color.Transparent)
            .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
            .fontSize($r('sys.float.ohos_id_text_size_button1'))
            .width('100%')
            .height('100%')
        }
        .width('100%')
      }
      .height(40)
      .margin({ top: 8, bottom: 16, left: 16, right: 16 })
    }
  }
}

const MARGIN_DISTANCE = 24;
const BORDER_DISTANCE = 16;

@Entry
@Component
export struct DialogPage {
  private want = globalThis.dialogWant as Want;
  private session = globalThis.dialogSession as UIExtensionContentSession;
  private appLabel: string = '';
  private overflow: boolean = false;

  dialogController: CustomDialogController = new CustomDialogController({
    builder: PrivacyWindowDialog({
      cancel: () => { this.onCancel() },
      confirm: () => { this.onConfirm() },
      appLabel: this.appLabel,
      overflow: this.overflow
    }),
    alignment: DialogAlignment.Center,
    autoCancel: false,
    backgroundColor: Color.White
  })

  getTextLength(text: Resource, fontSize: Resource): void {
    let textLength: number = measure.measureText({
      textContent: text,
      fontSize: fontSize
    });
    let windowWidth = display.getDefaultDisplaySync().width;
    let textMaxLength = px2vp(windowWidth) - BORDER_DISTANCE - MARGIN_DISTANCE;
    if (px2vp(textLength) > textMaxLength) {
      Log.showInfo(TAG, 'title overflow, need change line');
      this.overflow = true;
    } else {
      this.overflow = false;
    }
  }

  async onCancel(): Promise<void> {
    Log.showInfo(TAG, 'Cancel is clicked');
    globalThis.userChoice = 'false';
    await this.session.terminateSelf();
  }

  async onConfirm(): Promise<void> {
    Log.showInfo(TAG, 'Agree is clicked');
    globalThis.userChoice = 'true';
    await this.session.terminateSelf();
  }

  async onPageShow(): Promise<void> {
    this.getTextLength($r('app.string.avscreencapture_privacy_window_title'),
      $r('sys.float.ohos_id_text_size_headline8'));
    this.getAppName();
    Log.showInfo(TAG, 'onPageShow');
    this.dialogController.open();
  }

  onPageHide(): void {
    Log.showInfo(TAG, 'onPageHide')
  }

  getAppName(): void {
    if (this.want.parameters?.callingLabel) {
      this.appLabel = (this.want.parameters?.appLabel).toString();
      Log.showInfo(TAG, `appLabel: ${this.appLabel}`);
    }
  }

  build(){}
}