import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CandidatureDetail } from './candidature-detail';

describe('CandidatureDetail', () => {
  let component: CandidatureDetail;
  let fixture: ComponentFixture<CandidatureDetail>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [CandidatureDetail]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CandidatureDetail);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
