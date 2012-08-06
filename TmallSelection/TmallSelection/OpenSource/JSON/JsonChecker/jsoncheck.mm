
#include "JSON_checker.h"
#include "jsoncheck.h"

#ifndef NULL 
#define NULL 0
#endif 

#define JSONPARSE_MAX_STACK_DEEP 20	// copy from JSON_checker.h 20 should be enough



JsonCheck::JsonCheck()
{
	m_pJsonChecker = NULL;
}
JsonCheck::~JsonCheck()
{
	;
}
bool JsonCheck::Init()
{
	if (m_pJsonChecker)
	{
		return ReInit();
	}

	JSON_checker jc = new JSON_checker_struct;
	if (jc == NULL)
	{
		return false;
	}
	int depth = JSONPARSE_MAX_STACK_DEEP;
	jc->stack = new int[depth];
	if (jc->stack == NULL)
	{
		delete jc;
		return false;
	}
	jc->depth = depth;

	m_pJsonChecker = jc;
	return ReInit();
}

void JsonCheck::Release()
{
	JSON_checker jc = (JSON_checker) m_pJsonChecker;
	if (jc)
	{
		if (jc->stack)
		{
			delete []jc->stack;
			jc->stack = NULL;
		}
		delete jc;
		m_pJsonChecker = NULL;
	}
}
bool JsonCheck::ReInit()
{
	JSON_Init((JSON_checker)m_pJsonChecker);
	m_nProcessedCount = 0;
	return true;
}

JsonCheck::JsonStrChk JsonCheck::UpdateChar(char ch)
{
	++m_nProcessedCount;
	if (!JSON_checker_char((JSON_checker)m_pJsonChecker,  
		(int)(unsigned char)ch))
	{
		return JSTR_INVALID;
	}
	if (JSON_checker_done((JSON_checker)m_pJsonChecker))
	{
		return JSTR_OK;
	}
	return JSTR_NOCOMPLETE;
}

int JsonCheck::GetProcessedCount()
{
	return m_nProcessedCount;
}
