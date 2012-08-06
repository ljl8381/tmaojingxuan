
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
		JSTR_INVALID,	//无效数据
		JSTR_NOCOMPLETE,	//可能是json数据，目前数据不完整
		JSTR_OK,		//是json数据
	};

	JsonStrChk UpdateChar(char ch);
	int GetProcessedCount();

private:
	void *m_pJsonChecker;
	int m_nProcessedCount;
};


#endif // __JSONCHECK_H__

