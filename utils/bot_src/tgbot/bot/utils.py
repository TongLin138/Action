import re,os,datetime,asyncio
from functools import wraps
from telethon import events, Button
from .. import tgbot, chat_id, LOG_DIR, logger, ARCADIA_DIR, CONFIG_DIR, BOT_SET

row = int(BOT_SET['每页列数'])
BEAN_LOG_DIR = f'{LOG_DIR}/jd_bean_change/'
CONFIG_SH_FILE = f'{CONFIG_DIR}/config.sh'
TASK_CMD = 'task'


def get_cks(ckfile):
    ck_reg = re.compile(r'pt_key=\S*?;.*?pt_pin=\S*?;')
    with open(ckfile, 'r', encoding='utf-8') as f:
        lines = f.read()
    cookies = ck_reg.findall(lines)
    for ck in cookies:
        if ck == 'pt_key=xxxxxxxxxx;pt_pin=xxxx;':
            cookies.remove(ck)
            break
    return cookies


def split_list(datas, n, row: bool = True):
    """一维列表转二维列表，根据N不同，生成不同级别的列表"""
    length = len(datas)
    size = length / n + 1 if length % n else length/n
    _datas = []
    if not row:
        size, n = n, size
    for i in range(int(size)):
        start = int(i * n)
        end = int((i + 1) * n)
        _datas.append(datas[start:end])
    return _datas


def backup_file(file):
    '''如果文件存在，则备份，并更新'''
    if os.path.exists(file):
        try:
            os.rename(file, f'{file}.bak')
        except WindowsError:
            os.remove(f'{file}.bak')
            os.rename(file, f'{file}.bak')


def press_event(user_id):
    return events.CallbackQuery(func=lambda e: e.sender_id == user_id)

def reContent_INVALID(text):
    replaceArr = ['_', '*', '~']
    for i in replaceArr:
        t = ''
        for a in range(5):
            t += i
        text = re.sub('\%s{6,}' % i, t, text)
    return text

async def cmd(cmdtext, FotmatCode = False):
    '''定义执行cmd命令'''
    try:
        msg = await tgbot.send_message(chat_id, '开始执行命令')
        p = await asyncio.create_subprocess_shell(
            cmdtext + "| sed 's/\[3[0-9]m//g; s/\[4[0-9]\;3[0-9]m//g; s/\[[0-1]m//g'" + ' 2>&1', stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE)
        res_bytes, res_err = await p.communicate()
        res = res_bytes.decode('utf-8')
        res = reContent_INVALID(res)
        if len(res) == 0:
            await tgbot.edit_message(msg, '❌ 已执行命令但返回值为空，可能遇到了某些错误～')
        elif len(res) <= 4000:
            await tgbot.delete_messages(chat_id, msg)
            if FotmatCode:
                await tgbot.send_message(chat_id, f"```{res}```", link_preview=False)
            else:
                await tgbot.send_message(chat_id, res, link_preview=False)
        elif len(res) > 4000:
            tmp_log = f'{LOG_DIR}/TelegramBot/{cmdtext.split("/")[-1].split(".js")[0]}-{datetime.datetime.now().strftime("%H-%M-%S")}.log'
            with open(tmp_log, 'w+', encoding='utf-8') as f:
                f.write(res)
            await tgbot.delete_messages(chat_id, msg)
            await tgbot.send_message(chat_id, '执行结果较长，具体请查看日志文件内容', file=tmp_log)
            os.remove(tmp_log)
    except Exception as e:
        await tgbot.send_message(chat_id, f'something wrong,I\'m sorry\n{str(e)}')
        logger.error(f'something wrong,I\'m sorry\n{str(e)}')


def get_ch_names(path, dir):
    '''获取文件中文名称，如无则返回文件名'''
    file_ch_names = []
    reg = r'new Env\(\'[\S]+?\'\)'
    ch_name = False
    for file in dir:
        try:
            if os.path.isdir(f'{path}/{file}'):
                file_ch_names.append(file)
            elif file.endswith('.js') and file != 'jdCookie.js' and file != 'getJDCookie.js' and file != 'JD_extra_cookie.js' and 'ShareCode' not in file:
                with open(f'{path}/{file}', 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                for line in lines:
                    if 'new Env' in line:
                        line = line.replace('\"', '\'')
                        res = re.findall(reg, line)
                        if len(res) != 0:
                            res = res[0].split('\'')[-2]
                            file_ch_names.append(f'{res}-->{file}')
                            ch_name = True
                        break
                if not ch_name:
                    file_ch_names.append(f'{file}-->{file}')
                    ch_name = False
            else:
                continue
        except:
            continue
    return file_ch_names


async def log_btn(conv, sender, path, msg, page, files_list):
    '''定义log日志按钮'''
    buttons = [
        Button.inline("上一页", data="up"), 
        Button.inline("下一页", data="next"), 
        Button.inline("上级", data="updir"), 
        Button.inline("取消", data="cancel")
    ]
    try:
        if files_list:
            markup = files_list
            new_markup = markup[page]
            if buttons not in new_markup:
                new_markup.append(buttons)
        else:
            dir = os.listdir(path)
            dir.sort()
            if path == LOG_DIR:
                markup = [Button.inline("_".join(file.split("_")[-2:]), data=str(file))
                          for file in dir]
            elif os.path.dirname(os.path.realpath(path)) == LOG_DIR:
                markup = [Button.inline("-".join(file.split("-")[-5:]), data=str(file))
                          for file in dir]
            else:
                markup = [Button.inline(file, data=str(file))
                          for file in dir]
            markup = split_list(markup, row)
            if len(markup) > 30:
                markup = split_list(markup, 30)
                new_markup = markup[page]
                new_markup.append(buttons)
            else:
                new_markup = markup
                if path == ARCADIA_DIR:
                    new_markup.append([Button.inline('取消', data='cancel')])
                else:
                    new_markup.append(
                        [Button.inline('上级', data='updir'), Button.inline('取消', data='cancel')])
        msg = await tgbot.edit_message(msg, '请做出您的选择：', buttons=new_markup)
        convdata = await conv.wait_event(press_event(sender))
        res = bytes.decode(convdata.data)
        if res == 'cancel':
            msg = await tgbot.edit_message(msg, '对话已取消')
            conv.cancel()
            return None, None, None, None
        elif res == 'next':
            page = page + 1
            if page > len(markup) - 1:
                page = 0
            return path, msg, page, markup
        elif res == 'up':
            page = page - 1
            if page < 0:
                page = len(markup) - 1
            return path, msg, page, markup
        elif res == 'updir':
            path = '/'.join(path.split('/')[:-1])
            if path == '':
                path = ARCADIA_DIR
            return path, msg, page, None
        elif os.path.isfile(f'{path}/{res}'):
            msg = await tgbot.edit_message(msg, '文件发送中，请注意查收')
            await conv.send_file(f'{path}/{res}')
            msg = await tgbot.edit_message(msg, f'{res} 发送成功，请查收')
            conv.cancel()
            return None, None, None, None
        else:
            return f'{path}/{res}', msg, page, None
    except asyncio.exceptions.TimeoutError:
        msg = await tgbot.edit_message(msg, '选择已超时，本次对话已停止')
        return None, None, None, None
    except Exception as e:
        msg = await tgbot.edit_message(msg, f'something wrong,I\'m sorry\n{str(e)}')
        logger.error(f'something wrong,I\'m sorry\n{str(e)}')
        return None, None, None, None


async def run_btn(conv, sender, path, msg, page, files_list):
    '''定义scripts脚本按钮'''
    buttons = [
        Button.inline('上一页', data='up'),
        Button.inline('下一页', data='next'),
        Button.inline('上级', data='updir'),
        Button.inline('取消', data='cancel')
    ]
    try:
        if files_list:
            markup = files_list
            new_markup = markup[page]
            if buttons not in new_markup:
                new_markup.append(buttons)
        else:
            dir = os.listdir(path)
            # if BOT_SET["中文"].lower() == "true":
            #     dir = get_ch_names(path, dir)

            dir.sort()
            markup = [Button.inline(file.split('--->')[0], data=str(file.split('--->')[-1]))
                      for file in dir if os.path.isdir(f'{path}/{file}') or file.endswith(('.js', '.py', '.ts', '.sh')) and not re.match(r'AGENTS|^TS_|Cookie|cookie|Token|ShareCodes|sendNotify\.|^JDJR|Validator|validate|ZooFaker|MovementFaker|tencentscf|^api_test|^app\.|^main\.|\.bak\b|jdEnv|identical|jd_update\.js|env_copy\.js|index\.js|ql\.js|jCkSeq\.js|jd_CheckCK\.js|jdCookie\.js|jd_disable\.py|jd_updateCron\.ts|scripts_check_dependence\.py|UpdateUIDtoRemark\.js|^magic\.|test\.|wskey\.|h5\.js|h5st\.js|getToken\.js|telecom\.py|main\.py|depend\.py', file, re.S) ]
            markup = split_list(markup, row)
            if len(markup) > 30:
                markup = split_list(markup, 30)
                new_markup = markup[page]
                new_markup.append(buttons)
            else:
                new_markup = markup
                if path == ARCADIA_DIR:
                    new_markup.append([Button.inline('取消', data='cancel')])
                else:
                    new_markup.append(
                        [Button.inline('上级', data='updir'), Button.inline('取消', data='cancel')])
        msg = await tgbot.edit_message(msg, '请做出您的选择：', buttons=new_markup)
        convdata = await conv.wait_event(press_event(sender))
        res = bytes.decode(convdata.data)
        if res == 'cancel':
            msg = await tgbot.edit_message(msg, '对话已取消')
            conv.cancel()
            return None, None, None, None
        elif res == 'next':
            page = page + 1
            if page > len(markup) - 1:
                page = 0
            return path, msg, page, markup
        elif res == 'up':
            page = page - 1
            if page < 0:
                page = len(markup) - 1
            return path, msg, page, markup
        elif res == 'updir':
            path = '/'.join(path.split('/')[:-1])
            if path == '':
                path = ARCADIA_DIR
            return path, msg, page, None
        elif os.path.isfile(f'{path}/{res}'):
            conv.cancel()
            logger.info(f'{path}/{res} 脚本即将在后台运行')
            msg = await tgbot.edit_message(msg, f'{res} 已部署后台任务')
            cmdtext = f'{TASK_CMD} {path}/{res} now -b'
            return None, None, None, f'CMD-->{cmdtext}'
        else:
            return f'{path}/{res}', msg, page, None
    except asyncio.exceptions.TimeoutError:
        msg = await tgbot.edit_message(msg, '选择已超时，对话已停止')
        return None, None, None, None
    except Exception as e:
        msg = await tgbot.edit_message(msg, f'something wrong,I\'m sorry\n{str(e)}')
        logger.error(f'something wrong,I\'m sorry\n{str(e)}')
        return None, None, None, None

# 获取内容中的定时表达式
def get_cron(lines):
    cronreg = re.compile(r'([0-9\-\*/,]{1,} ){4,5}([0-9\-\*/,]){1,}')
    return cronreg.search(lines).group()


async def add_cron(tgbot, conv, resp, filename, msg, sender, markup, path):
    try:
        crondata = f'{get_cron(resp)} task {path}/{filename}'
        msg = await tgbot.edit_message(msg, f'已识别定时\n```{crondata}```\n是否需要修改', buttons=markup)
    except:
        crondata = f'0 0 * * * task {path}/{filename}'
        msg = await tgbot.edit_message(msg, f'未识别到定时，默认定时\n```{crondata}```\n是否需要修改', buttons=markup)
    convdata3 = await conv.wait_event(press_event(sender))
    res3 = bytes.decode(convdata3.data)
    if res3 == 'yes':
        convmsg = await conv.send_message(f'```{crondata}```\n请输入您要修改内容，可以直接点击上方定时进行复制修改\n如果需要取消，请输入`cancel`或`取消`')
        crondata = await conv.get_response()
        crondata = crondata.raw_text
        if crondata == 'cancel' or crondata == '取消':
            conv.cancel()
            await tgbot.send_message(chat_id, '对话已取消')
            return
        await tgbot.delete_messages(chat_id, convmsg)
    await tgbot.delete_messages(chat_id, msg)

    ## 定时任务添加（待编写）

    await tgbot.send_message(chat_id, f'{filename}已保存到{path}，并已尝试添加定时任务')