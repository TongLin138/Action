import React, { useEffect, useState } from 'react';
import {
  Modal,
  message,
  Input,
  Form,
  Button,
  Card,
  Tag,
  List,
  Divider,
} from 'antd';
import {
  ClockCircleOutlined,
  CloseCircleOutlined,
  FieldTimeOutlined,
  Loading3QuartersOutlined,
  FileOutlined,
} from '@ant-design/icons';
import { CrontabStatus } from './index';
import { diffTime } from '@/utils/date';
import { request } from '@/utils/http';
import config from '@/utils/config';
import CronLogModal from './logModal';
import Editor from '@monaco-editor/react';

const tabList = [
  {
    key: 'log',
    tab: '日志',
  },
  {
    key: 'script',
    tab: '脚本',
  },
];

interface LogItem {
  directory: string;
  filename: string;
}

const language = navigator.language || navigator.languages[0];

const CronDetailModal = ({
  cron = {},
  handleCancel,
  visible,
  theme,
}: {
  cron?: any;
  visible: boolean;
  handleCancel: (needUpdate?: boolean) => void;
  theme: string;
}) => {
  const [activeTabKey, setActiveTabKey] = useState('log');
  const [loading, setLoading] = useState(true);
  const [logs, setLogs] = useState<LogItem[]>([]);
  const [log, setLog] = useState('');
  const [value, setValue] = useState('');
  const [isLogModalVisible, setIsLogModalVisible] = useState(false);

  const contentList: any = {
    log: (
      <List
        dataSource={logs}
        loading={loading}
        renderItem={(item) => (
          <List.Item className="log-item" onClick={() => onClickItem(item)}>
            <FileOutlined style={{ marginRight: 10 }} />
            {item.directory}/{item.filename}
          </List.Item>
        )}
      />
    ),
    script: (
      <Editor
        language="shell"
        theme={theme}
        value={value}
        options={{
          readOnly: true,
          fontSize: 12,
          lineNumbersMinChars: 3,
          fontFamily: 'Source Code Pro',
          folding: false,
          glyphMargin: false,
          wordWrap: 'on',
        }}
      />
    ),
  };

  const onClickItem = (item: LogItem) => {
    request
      .get(`${config.apiPrefix}logs/${item.directory}/${item.filename}`)
      .then((data) => {
        setLog(data.data);
        setIsLogModalVisible(true);
      });
  };

  const onTabChange = (key: string) => {
    setActiveTabKey(key);
  };

  const getLogs = () => {
    setLoading(true);
    request
      .get(`${config.apiPrefix}crons/${cron.id}/logs`)
      .then((data: any) => {
        if (data.code === 200) {
          setLogs(data.data);
        }
      })
      .finally(() => setLoading(false));
  };

  const getScript = () => {
    const cmd = cron.command.split(' ') as string[];
    if (cmd[0] === 'task') {
      if (cmd[1].startsWith('/ql/data/scripts')) {
        cmd[1] = cmd[1].replace('/ql/data/scripts/', '');
      }

      let [p, s] = cmd[1].split('/');
      if (!s) {
        s = p;
        p = '';
      }
      request
        .get(`${config.apiPrefix}scripts/${s}?path=${p || ''}`)
        .then((data) => {
          setValue(data.data);
        });
    }
  };

  useEffect(() => {
    if (cron && cron.id) {
      getLogs();
      getScript();
    }
  }, [cron]);

  return (
    <Modal
      title={
        <>
          <span>{cron.name}</span>
          <Divider type="vertical"></Divider>
          {cron.labels?.length > 0 &&
            cron.labels[0] !== '' &&
            cron.labels?.map((label: string, i: number) => (
              <Tag color="blue" style={{ marginRight: 5 }}>
                {label}
              </Tag>
            ))}
        </>
      }
      centered
      visible={visible}
      forceRender
      footer={false}
      onCancel={() => handleCancel()}
      width={'80vw'}
      bodyStyle={{ background: '#eee', padding: 12 }}
    >
      <div style={{ height: '80vh' }}>
        <Card bodyStyle={{ display: 'flex', justifyContent: 'space-between' }}>
          <div className="cron-detail-info-item">
            <div className="cron-detail-info-title">状态</div>
            <div className="cron-detail-info-value">
              {(!cron.isDisabled || cron.status !== CrontabStatus.idle) && (
                <>
                  {cron.status === CrontabStatus.idle && (
                    <Tag icon={<ClockCircleOutlined />} color="default">
                      空闲中
                    </Tag>
                  )}
                  {cron.status === CrontabStatus.running && (
                    <Tag
                      icon={<Loading3QuartersOutlined spin />}
                      color="processing"
                    >
                      运行中
                    </Tag>
                  )}
                  {cron.status === CrontabStatus.queued && (
                    <Tag icon={<FieldTimeOutlined />} color="default">
                      队列中
                    </Tag>
                  )}
                </>
              )}
              {cron.isDisabled === 1 && cron.status === CrontabStatus.idle && (
                <Tag icon={<CloseCircleOutlined />} color="error">
                  已禁用
                </Tag>
              )}
            </div>
          </div>
          <div className="cron-detail-info-item">
            <div className="cron-detail-info-title">任务</div>
            <div className="cron-detail-info-value">{cron.command}</div>
          </div>
          <div className="cron-detail-info-item">
            <div className="cron-detail-info-title">定时</div>
            <div className="cron-detail-info-value">{cron.schedule}</div>
          </div>
          <div className="cron-detail-info-item">
            <div className="cron-detail-info-title">最后运行时间</div>
            <div className="cron-detail-info-value">
              {cron.last_execution_time
                ? new Date(cron.last_execution_time * 1000)
                    .toLocaleString(language, {
                      hour12: false,
                    })
                    .replace(' 24:', ' 00:')
                : '-'}
            </div>
          </div>
          <div className="cron-detail-info-item">
            <div className="cron-detail-info-title">最后运行时长</div>
            <div className="cron-detail-info-value">
              {cron.last_running_time ? diffTime(cron.last_running_time) : '-'}
            </div>
          </div>
          <div className="cron-detail-info-item">
            <div className="cron-detail-info-title">下次运行时间</div>
            <div className="cron-detail-info-value">
              {cron.nextRunTime &&
                cron.nextRunTime
                  .toLocaleString(language, {
                    hour12: false,
                  })
                  .replace(' 24:', ' 00:')}
            </div>
          </div>
        </Card>
        <Card
          style={{ marginTop: 16 }}
          tabList={tabList}
          activeTabKey={activeTabKey}
          onTabChange={(key) => {
            onTabChange(key);
          }}
          bodyStyle={{ height: 'calc(80vh - 188px)', overflowY: 'auto' }}
        >
          {contentList[activeTabKey]}
        </Card>
      </div>
      <CronLogModal
        visible={isLogModalVisible}
        handleCancel={() => {
          setIsLogModalVisible(false);
        }}
        cron={cron}
        data={log}
      />
    </Modal>
  );
};

export default CronDetailModal;