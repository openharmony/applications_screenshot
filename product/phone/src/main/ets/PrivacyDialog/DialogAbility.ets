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
import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import media from '@ohos.multimedia.media';
import Log from '../../../../../../common/src/main/ets/default/Log';
import Want from '@ohos.app.ability.Want';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { BusinessError } from '@ohos.base';

const TAG = 'AVScreenCapture-DiaLogUIExtensionAbility';

export default class DialogAbility extends UIExtensionAbility {
  onCreate(): void {
    Log.showInfo(TAG, 'DialogAbility onCreate');
    globalThis.sessionId = -1;
    globalThis.userChoice = 'false';
  }

  onForeground(): void {
    Log.showInfo(TAG, 'DialogAbility onForeground');
  }

  onBackground(): void {
    Log.showInfo(TAG, 'DialogAbility onBackground');
  }

  onDestroy(): void {
    Log.showInfo(TAG, `Report user choice sessionId(${globalThis.sessionId}), userChoice(${globalThis.userChoice})`);
    media.reportAVScreenCaptureUserChoice(Number(globalThis.sessionId), globalThis.userChoice);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    Log.showInfo(TAG, 'onSessionCreate');
    globalThis.dialogContext = this.context;
    globalThis.dialogWant = want;
    globalThis.dialogSession = session;
    globalThis.sessionId = want.parameters?.sessionId as number;
    let param: Record<string, UIExtensionContentSession> = {
      'session': session
    }
    let storage: LocalStorage = new LocalStorage(param);
    try {
      session.loadContent('PrivacyDialog/DialogPage', storage);
    } catch (err) {
      Log.showError(TAG, 'session loadContent error: ' + (err as BusinessError).message);
    }
    session.setWindowBackgroundColor('#00ffffff');
  }

  onSessionDestroy(session: UIExtensionContentSession): void {
    Log.showInfo(TAG, 'UIExtAbility onSessionDestroy');
  }
}