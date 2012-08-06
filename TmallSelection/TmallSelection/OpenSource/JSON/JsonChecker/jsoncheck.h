
#ifndef __JSONCHECK_H__
#define __JSONCHECK_H__


class JsonCheck
{
public:
	JsonCheck();
	~JsonCheck();
	bool Init();
	void Release();
	bool ReInit();

	// methods.
	enum JsonStrChk
	{
		JSTR_INVALID,	//��Ч����
		JSTR_NOCOMPLETE,	//������json���ݣ�Ŀǰ���ݲ�����
		JSTR_OK,		//��json����
	};

	JsonStrChk UpdateChar(char ch);
	int GetProcessedCount();

private:
	void *m_pJsonChecker;
	int m_nProcessedCount;
};


#endif // __JSONCHECK_H__

